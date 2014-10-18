require 'sinatra'
require 'sinatra/json'
require 'sinatra/sequel'

set :public_folder, -> { File.join(root, 'www') }
enable :static

unless ENV.key?('DATABASE_URL')
  set :database, 'postgres://localhost:5432/globallinks'
end

# FIXME: Yup this is hosed wat
# migration 'create the users table' do
#   database.create_table :users do
#     primary_key :id
#     String :username, null: false
#     String :email, null: false
#     String :volunteer_id, null: false
#     String :password, null: false
#     timestamp :created_at, null: false, default: 'current_timestamp'
#     timestamp :modifiet_at, null: false, default: 'current_timestamp'
#
#     index :username
#   end
# end

class User < Sequel::Model
end

get '/user/:id' do
  json user: database[:users].filter(id: params[:id]).first
end

post '/user' do
  database[:users] << User.new(params)
  status 201
  ''
end

get '/scare' do
  content_type 'text/plain'
  "boo\n"
end
