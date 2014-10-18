source 'https://rubygems.org'

ruby File.read('.ruby-version').strip if ENV.key?('DYNO')

gem 'eventmachine', platforms: [:ruby, :mswin, :mingw]
gem 'ffi', platforms: [:ruby, :mswin, :mingw]
gem 'pg', platforms: [:ruby, :mswin, :mingw]
gem 'rake'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'sinatra-sequel'
gem 'thin'
gem 'win32console', platforms: [:mswin, :mingw]

group :test do
  gem 'pry', platforms: [:ruby, :mswin, :mingw]
  gem 'rerun'
  gem 'rspec'
  gem 'rubocop'
  gem 'simplecov'
end
