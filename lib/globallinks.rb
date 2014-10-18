require 'sinatra'
require 'sinatra/json'
require 'sinatra/sequel'

if Sinatra::Base.development? || Sinatra::Base.test?
  require 'dotenv'
  Dotenv.load
end

set :root, File.expand_path('../../', __FILE__)
set :public_folder, -> { File.join(root, 'www') }
enable :static

set :database, ENV.fetch('DATABASE_URL')

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

class User < Sequel::Model
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
  database[:users] << User.new(params)
  status 201
  ''
end

get '/scare' do
  content_type 'text/plain'
  "boo\n"
end
