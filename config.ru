$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'volunteer_portal/app'

run Sinatra::Application
