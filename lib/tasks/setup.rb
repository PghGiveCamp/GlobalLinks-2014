require 'uri'

def dbname
  @dbname ||= begin
    unless ENV.key?('DATABASE_URL')
      $stderr.puts "\n---> ERROR: no DATABASE_URL set. <---"
      $stderr.puts "---> ERROR: Check the README.md <---\n\n"
      fail
    end

    dburl = URI(ENV['DATABASE_URL'])
    dburl.path.sub(/^\//, '')
  end
end

task :npm_install do
  sh 'npm install'
end

task :psql_createdb do
  if `psql -l -t -A`.split("\n").grep(/^#{dbname}\|/).empty?
    sh "createdb #{dbname}"
  end
end

task setup: [:npm_install, :psql_createdb]
