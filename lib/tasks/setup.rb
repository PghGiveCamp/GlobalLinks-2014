require 'uri'

def dbname
  @dbname ||= begin
    unless ENV.key?('DATABASE_URL')
      $stderr.puts "\n---> ERROR: no DATABASE_URL set. Check the README.md <---\n\n"
      fail
    end

    dburl = URI(ENV['DATABASE_URL'])
    dburl.path.sub(/^\//, '')
  end
end

task :setup do
  sh 'npm install'
  if `psql -l -t -A`.split("\n").grep(/^#{dbname}\|/).empty?
    sh "createdb #{dbname}"
  end
end
