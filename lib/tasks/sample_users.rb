module Tasks
  class SampleUsers
    def initialize
      require 'faraday'
      require 'faraday_middleware'
      require 'uri'
    end

    def fetch
      JSON.pretty_generate(
        build_users(
          conn.get('/repos/globallinks/volunteer-portal/contributors').body
        )
      )
    end

    private

    def build_users(collaborators)
      collaborators.each_with_object({}) do |user, h|
        email = conn.get(URI(user.fetch('url')).path).body['email']
        next if email.nil? || email.empty?

        h[email] = {
          username: user.fetch('login'),
          password: 'changeme'
        }
      end
    end

    def conn
      @conn ||= Faraday.new(url: github_api) do |faraday|
        faraday.basic_auth(github_token, 'x-oauth-basic') if github_token
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    def github_token
      @github_token ||= ENV['GITHUB_TOKEN']
    end

    def github_api
      @github_api ||= ENV['GITHUB_API'] || 'https://api.github.com'
    end
  end
end

task :print_sample_users do
  puts sample_users
end

task :generate_sample_users do
  outfile = File.expand_path('../../../sampledata/users.json', __FILE__)
  File.write(outfile, sample_users)
  puts "new users written to #{outfile}"
end
