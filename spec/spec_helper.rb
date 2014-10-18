require 'coveralls'
require 'simplecov'
require 'rack/test'
require 'json'

ENV['RACK_ENV'] = 'test'
ENV['SALT'] = '42'

require 'globallinks'
require 'globallinks/password_hasher'

Volunteer.unrestrict_primary_key

SimpleCov.start
Coveralls.wear!
