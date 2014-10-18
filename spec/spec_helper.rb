require 'coveralls'
require 'simplecov'
require 'rack/test'
require 'json'

ENV['RACK_ENV'] = 'test'
ENV['SALT'] = '42'

require 'globallinks'
require 'globallinks/password_hasher'

SimpleCov.start
Coveralls.wear!
