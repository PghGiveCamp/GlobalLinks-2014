require 'uri'

def dburl
  unless ENV.key?('DATABASE_URL')
    $stderr.puts "\n---> ERROR: no DATABASE_URL set. <---"
    $stderr.puts "---> ERROR: Check the README.md <---\n\n"
    fail
  end

  @dburl ||= URI(ENV['DATABASE_URL'])
end

def dbname
  @dbname ||= dburl.path.sub(/^\//, '')
end

def dbuser
  @dbuser ||= dburl.user || `whoami`
end

def sampledata_dir
  File.expand_path('../../../sampledata', __FILE__)
end

namespace :setup do
  task :npm_install do
    sh 'npm install'
  end

  task :psql_createdb do
    if `psql -l -t -A`.split("\n").grep(/^#{dbname}\|/).empty?
      sh "createdb #{dbname} --owner #{dbuser}"
    end
  end

  task :migrate do
    $LOAD_PATH << File.expand_path('../../', __FILE__)
    require 'volunteer_portal/app'
  end

  task :load_sampledata do
    Dir.chdir(sampledata_dir) do
      require './load'
      Sampledata.load_all.each do |line|
        puts line
      end
    end
  end
end

namespace :reset do
  task :wipe_sampledata do
    Dir.chdir(sampledata_dir) do
      sh "psql '#{ENV['DATABASE_URL']}' < wipe.sql"
    end
  end
end

task reset: [:'reset:wipe_sampledata']

task setup: [
  :'setup:npm_install',
  :'setup:psql_createdb',
  :'setup:migrate',
  :'setup:load_sampledata'
]
