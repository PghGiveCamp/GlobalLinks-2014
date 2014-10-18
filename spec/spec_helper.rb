require 'coveralls'
require 'simplecov'
require 'rack/test'
require 'json'
require 'globallinks'

ENV['RACK_ENV'] ||= 'test'
SimpleCov.start
Coveralls.wear!
