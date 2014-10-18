require 'coveralls'
require 'simplecov'
require 'rack/test'
require 'json'
require 'globallinks'

Volunteer.unrestrict_primary_key

ENV['RACK_ENV'] ||= 'test'
SimpleCov.start
Coveralls.wear!
