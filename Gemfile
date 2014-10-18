source 'https://rubygems.org'

ruby File.read('.ruby-version').strip if ENV.key?('DYNO')

gem 'pg'
gem 'puma'
gem 'rake'
gem 'sinatra'
gem 'sinatra-sequel'

group :test do
  gem 'pry'
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov'
end
