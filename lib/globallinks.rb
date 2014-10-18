require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/json'
require 'sinatra/sequel'
require 'dalli'
require 'rack/session/dalli'

if Sinatra::Base.development? || Sinatra::Base.test?
  require 'dotenv'
  Dotenv.load
end

set :root, File.expand_path('../../', __FILE__)
set :public_folder, -> { File.join(root, 'www') }
set :cookie_options, httponly: false
enable :static

set :database, ENV.fetch('DATABASE_URL')

configure do
  unless ENV['RACK_ENV'] == 'test'
    use Rack::Session::Dalli, cache: Dalli::Client.new
  end
end

migration 'create users table' do
  database.create_table :users do
    primary_key :id
    String :username, null: false
    String :email, null: false
    String :volunteer_id, null: false
    String :password, null: false
    timestamp :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    timestamp :modifiet_at, null: false, default: Sequel::CURRENT_TIMESTAMP

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

class User < Sequel::Model
end

class Volunteer < Sequel::Model
end

get '/' do
  send_file 'www/index.html', type: :html
end

get '/user/:id' do
  json user: database[:users].filter(id: params[:id]).first
end

put '/user/:id' do
  status 501
end

post '/user' do
  # TODO: implementation for real
  User.create(params)
  status 201
  ''
end

get '/scare' do
  content_type 'text/plain'
  "boo\n"
end

post '/login' do
  halt 400 unless params[:username]

  user = database[:users].filter(username: params[:username]).first
  halt 404 if user.nil?
  halt 401 if user[:password] != params[:password]

  session[:username] = params[:username]
  session[:user_id] = user[:id]
  cookies[:_li] = '1'

  status 201
  json yes: :good, username: params[:username]
end

post '/logout' do
  session.clear
  status 201
  json yes: :good
end
