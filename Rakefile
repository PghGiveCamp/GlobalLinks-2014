begin
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'
rescue LoadError => e
  warn e
end

Dir.glob('lib/tasks/*.rb') do |rb|
  begin
    load rb
  rescue LoadError => e
    warn e
  end
end

RSpec::Core::RakeTask.new if defined?(RSpec)

RuboCop::RakeTask.new if defined?(RuboCop)

task default: [:rubocop, :spec]
