begin
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'
rescue LoadError => e
  warn e
end

RSpec::Core::RakeTask.new if defined?(RSpec)

RuboCop::RakeTask.new if defined?(RuboCop)

task :setup do
  sh 'npm install'
end

task 'assets:precompile' => :setup do
  puts 'This task is here so that setup runs on heroku'
  puts 'See: https://github.com/heroku/heroku-buildpack-ruby#flow'
end

task default: [:rubocop, :spec]
