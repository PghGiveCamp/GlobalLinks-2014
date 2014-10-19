def get_sample_users
  require 'faraday'
  require 'faraday_middleware'
  require 'uri'

  github_token = ENV['GITHUB_TOKEN']
  github_api = ENV['GITHUB_API'] || 'https://api.github.com'

  conn = Faraday.new(url: github_api) do |faraday|
    faraday.basic_auth(github_token, 'x-oauth-basic') if github_token
    faraday.response :json, content_type: /\bjson$/
    faraday.adapter Faraday.default_adapter
  end

  response = conn.get('/repos/globallinks/volunteer-portal/contributors')
  users = response.body.each_with_object({}) do |user, h|
    email = conn.get(URI(user.fetch('url')).path).body['email']
    next if email.nil? || email.empty?

    h[email] = {
      username: user.fetch('login'),
      password: 'changeme'
    }
  end

  JSON.pretty_generate(users)
end

task :print_sample_users do
  puts get_sample_users
end

task :generate_sample_users do
  outfile = File.expand_path('../../../sampledata/users.json', __FILE__)
  File.write(outfile, get_sample_users)
  puts "new users written to #{outfile}"
end
