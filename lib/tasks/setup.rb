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
  @dbname ||= begin
    dburl.path.sub(/^\//, '')
  end
end

def dbuser
  @dbuser ||= dburl.user || `whoami`
end

task :npm_install do
  sh 'npm install'
end

task :psql_createdb do
  if `psql -l -t -A`.split("\n").grep(/^#{dbname}\|/).empty?
    sh "createdb #{dbname} --owner #{dbuser}"
  end
end

task setup: [:npm_install, :psql_createdb]
