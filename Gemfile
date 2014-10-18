source 'https://rubygems.org'

ruby File.read('.ruby-version').strip if ENV.key?('DYNO')

gem 'pg'
gem 'puma'
gem 'sinatra'
gem 'sinatra-sequel'

group :test do
  gem 'rspec'
  gem 'pry'
end
