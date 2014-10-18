require 'coveralls'
require 'simplecov'
require 'rack/test'
require 'json'
require 'globallinks'

Volunteer.unrestrict_primary_key

ENV['RACK_ENV'] ||= 'test'

Volunteer.unrestrict_primary_key

RSpec.configure do |c|
  c.around(:each) do |example|
    Sinatra::Application.database.transaction(:rollback=>:always, :auto_savepoint=>true){example.run}
  end
end


SimpleCov.start
Coveralls.wear!
