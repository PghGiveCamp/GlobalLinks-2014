require 'sequel'
require 'securerandom'
require 'volunteer_portal/password_hasher'

module Sampledata
  def load_all
    loader = Loader.new
    output = []
    output << loader.load_volunteers
    output << loader.load_users
    output
  end

  module_function :load_all

  class Loader
    def load_volunteers(file = 'volunteers.csv')
      sql = "\\copy volunteers FROM '#{file}' DELIMITER ',' CSV HEADER"
      `psql '#{db.url}' -a -c "#{sql}"`
    end

    def load_users(users = users)
      output = []
      users.each do |email, user|
        next if db[:users].filter(email: email).first
        load_user(email, user)
        output << "Added user for #{email}"
      end
      output
    end

    private

    def load_user(email, user)
      ensure_volunteer_exists!(email)
      db[:users] << {
        username: user['username'],
        email: email,
        volunteer_id: volunteer_id(email),
        password: hasher.hash_password(user['raw_password'])
      }
    end

    def volunteer_id(email)
      volunteer(email).fetch(:id)
    end

    def volunteer(email)
      db[:volunteers].filter(preferred_email: email).first
    end

    def ensure_volunteer_exists!(email)
      return if volunteer(email)
      db[:volunteers] << {
        id: SecureRandom.uuid,
        preferred_email: email,
        checked_in: false
      }
    end

    def hasher
      @hasher ||= VolunteerPortal::PasswordHasher.new(salt: ENV.fetch('SALT'))
    end

    def db
      @db ||= Sequel.connect(ENV.fetch('DATABASE_URL'))
    end

    def users(users_file = 'users.json')
      @users ||= JSON.parse(File.read(users_file))
    end
  end
end
