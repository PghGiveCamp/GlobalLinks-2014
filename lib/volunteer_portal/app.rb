require 'logger'
require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/json'
require 'sinatra/sequel'
require 'dalli'
require 'rack/session/dalli'
require 'pony'

require_relative 'password_hasher'

$logger = Logger.new(STDOUT)

if Sinatra::Base.development? || Sinatra::Base.test?
  require 'dotenv'
  Dotenv.load
end

set :root, File.expand_path('../../../', __FILE__)
set :public_folder, -> { File.join(root, 'www') }
set :cookie_options, httponly: false
enable :static

set :database, ENV.fetch('DATABASE_URL')

configure do
  unless ENV['RACK_ENV'] == 'test'
    use Rack::Session::Dalli, cache: Dalli::Client.new
  end
end

Pony.options = {
  via: :smtp,
  via_options: {
    address: ENV.fetch('SMTP_HOST'),
    port: ENV.fetch('SMTP_PORT'),
    enable_starttls_auto: ENV.fetch('SMTP_TLS'),
    user_name: ENV.fetch('SMTP_USERNAME'),
    password: ENV.fetch('SMTP_PASSWORD'),
    authentication: ENV.fetch('SMTP_AUTH'),
    domain: ENV.fetch('SMTP_DOMAIN')
  }
}

if ENV['RACK_ENV'] != 'production'
  module Pony
    def self.deliver(mail)
      $logger.info("Would have sent mail: #{mail.inspect}")
    end
  end
end

migration 'create users table' do
  database.create_table :users do
    primary_key :id
    String :username, null: false
    String :email, null: false
    String :volunteer_id, null: false
    String :password, null: false
    String :reset_token,  fixed: true, size: 36
    timestamp :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    timestamp :modified_at, null: false, default: Sequel::CURRENT_TIMESTAMP

    index :username
  end
end

migration 'create volunteer table' do
  database.create_table :volunteers do
    String :id, null: false, primary_key: true
    String :volunteer_status, null: true
    String :salutation, null: true
    String :first_name, null: true
    String :last_name, null: true
    String :address, null: true
    String :city, null: true
    String :state, null: true
    String :zip, null: true
    String :country, null: true
    DateTime :last_checkin, null: true
    TrueClass :checked_in, null: true
    String :username, null: true
    String :home_phone, null: true
    String :mobile_phone, null: true
    String :work_phone, null: true
    String :preferred_email_type, null: true
    String :preferred_email, null: true
    String :home_email, null: true
    String :alternate_email, null: true
    String :work_email, null: true
    BigDecimal :volunteer_hours, null: true
    String :emergency_name, null: true
    String :emergency_phone, null: true
    String :emergency_relationship, null: true
    String :emergency_phone_type, null: true
  end
end
exposed_volunteer_fields = [:address, :city, :state, :zip, :country,
                            :home_phone, :mobile_phone, :work_phone,
                            :home_email, :alternate_email, :work_email,
                            :emergency_name, :emergency_phone,
                            :emergency_relationship, :emergency_phone_type,
                            :checked_in, :volunteer_hours, :last_checkin]

Sequel::Model.plugin :json_serializer

class User < Sequel::Model
  many_to_one :volunteer # actually 1:1
end

class Volunteer < Sequel::Model
  one_to_one :user

  def full_name
    "#{first_name} #{last_name}"
  end
end

helpers do
  def current_user
    @current_user ||= User[id: session[:user_id]]
  end

  def signed_in?
    !current_user.nil?
  end

  def hasher
    @hasher ||= VolunteerPortal::PasswordHasher.new(salt: ENV.fetch('SALT'))
  end

  def login(user_id)
    session[:user_id] = user_id
    cookies[:_li] = '1'
  end

  def send_password_reset(volunteer, token)
    email_body = <<HTML
      <p>Hello #{volunteer.full_name},</p>
      <p>Click the link below to set your password.</p>
      <p>
        <a href="#{request.host}/auth/resetpassword/#{token}">
          #{request.host}/auth/resetpassword/#{token}
        </a>
      </p>
HTML
    Pony.mail(
      to: volunteer.preferred_email,
      subject: 'Reset GlobalLinks Volunteer Portal Password',
      html_body: email_body
    )
  end
end

get '/' do
  send_file 'www/index.html', type: :html
end

post '/user' do
  email = params[:email]
  username = params[:username]
  volunteers = Volunteer.where(preferred_email: email).to_a
  halt 404 unless volunteers.any?
  halt 409, json(error_type: :ACCOUNT_EXISTS) if User.find(username: username)

  if volunteers.count == 1
    volunteer = volunteers.first
    halt 409, json(error_type: :WRONG_USERNAME) if volunteer.username &&
                                            volunteer.username != username
  else
    volunteer = volunteers.find { |v| v.username == username }
    halt 409, json(error_type: :MULTIPLE_MATCHES) unless volunteer
  end

  user = User.create(username: username,
                     email: email,
                     password: hasher.hash_password(params[:password]),
                     volunteer_id: volunteer.id)
  login(user.id)
  status 201
end

get '/contact' do
  halt 401 unless signed_in?

  json current_user.volunteer
end

post '/contact' do
  halt 401 unless signed_in?

  json current_user.volunteer.update_fields(params, exposed_volunteer_fields)
end

post '/login' do
  halt 400 unless params[:username]

  user = User[username: params[:username]]
  halt 404 if user.nil?
  halt 401 if user[:password] != hasher.hash_password(params[:password])

  login(user[:id])

  status 201
  json username: params[:username]
end

post '/logout' do
  halt 401 unless signed_in?
  session.clear
  cookies.clear
  status 204
end

post '/contact/checkin' do
  halt 401 unless signed_in?
  halt 412 if current_user.volunteer.checked_in

  current_user.volunteer.update(checked_in: true, last_checkin: Time.now)
  status 200
end

post '/contact/checkout' do
  halt 401 unless signed_in?
  halt 412 unless current_user.volunteer.checked_in

  hours = current_user.volunteer.volunteer_hours || 0
  hours += (Time.now - current_user.volunteer.last_checkin) / 3600
  current_user.volunteer.update(checked_in: false,
                                volunteer_hours: hours.round(2))
  status 200
end

post '/reset_password_request' do
  halt 400 unless params[:user_identifier]

  volunteer = Volunteer.where(
    Sequel.expr(username: params[:user_identifier]) |
    Sequel.expr(preferred_email: params[:user_identifier])
  ).first

  halt 404 unless volunteer

  token = SecureRandom.uuid
  volunteer.user.update(reset_token: token)

  send_password_reset(volunteer, token)

  status 201
end

post '/reset_password' do
  user = User[reset_token: params[:reset_token]]

  halt 404 unless user

  user.update(
    reset_token: nil,
    password: hasher.hash_password(params[:password])
  )

  status 200
end
