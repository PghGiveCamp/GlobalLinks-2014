source 'https://rubygems.org'

ruby File.read('.ruby-version').strip if ENV.key?('DYNO')

gem 'dalli'
gem 'execjs'  # to trigger node install on heroku
gem 'pg'
gem 'rake'
gem 'rack-parser'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-sequel'
gem 'thin'
gem 'pony'

group :development, :test do
  gem 'coveralls', require: false
  gem 'dotenv'
end

group :test do
  gem 'faraday', require: false
  gem 'faraday_middleware', require: false
  gem 'pry'
  gem 'rack-test'
  gem 'rerun'
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov'
end
