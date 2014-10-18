require 'coveralls'
require 'simplecov'
require 'rack/test'
require 'json'

ENV['RACK_ENV'] = 'test'
ENV['SALT'] = '42'

require 'volunteer_portal/app'
require 'volunteer_portal/password_hasher'

Volunteer.unrestrict_primary_key

RSpec.configure do |c|
  c.around(:each) do |example|
    Sinatra::Application.database.transaction(
      rollback: :always,
      auto_savepoint: true
    ) do
      example.run
    end
  end
end

SimpleCov.start
Coveralls.wear!
