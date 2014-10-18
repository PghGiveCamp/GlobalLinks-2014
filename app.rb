require 'sinatra'

set :public_folder, -> { File.join(root, 'www') }
enable :static

get '/scare' do
  content_type 'text/plain'
  "boo\n"
end
