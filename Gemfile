source 'https://rubygems.org'

ruby File.read('.ruby-version').strip if ENV.key?('DYNO')

gem 'execjs'  # to trigger node install on heroku
gem 'pg'
gem 'rake'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-sequel'
gem 'thin'

group :development, :test do
  gem 'dotenv'
end

group :test do
  gem 'pry'
  gem 'rerun'
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov'
end
