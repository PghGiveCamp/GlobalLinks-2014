module Tasks
  class SampleUsers
    def initialize
      require_everything
    end

    def fetch
      JSON.pretty_generate(
        build_users(
          conn.get('/repos/globallinks/volunteer-portal/contributors').body
        )
      )
    end

    private

    def require_everything
      require 'faraday'
      require 'faraday_middleware'
      require 'json'
      require 'uri'
    end


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
  puts Tasks::SampleUsers.new.fetch
end

task :generate_sample_users do
  outfile = File.expand_path('../../../sampledata/users.json', __FILE__)
  File.write(outfile, Tasks::SampleUsers.new.fetch)
  puts "new users written to #{outfile}"
end
