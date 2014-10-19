require 'sequel'
require 'volunteer_portal/password_hasher'

module Sampledata
  def load_all
    loader = Loader.new
    loader.load_users
  end

  module_function :load_all

  class Loader
    USERS = {
      'amcoder@gmail.com' => {
        username: 'amcoder',
        raw_password: 'changeme'
      }
    }

    def load_users(users = USERS)
      users.each do |email, user|
        next if db[:users].filter(email: email).first
        load_user(email, user)
      end
    end

    private

    def load_user(email, user)
      db[:users] << {
        username: user[:username],
        email: email,
        volunteer_id: volunteer_id(email),
        password: hasher.hash_password(user[:raw_password])
      }
    end

    def volunteer_id(email)
      db[:volunteers].filter(preferred_email: email).first.fetch(:id)
    end

    def hasher
      @hasher ||= VolunteerPortal::PasswordHasher.new(salt: ENV.fetch('SALT'))
    end

    def db
      @db ||= Sequel.connect(ENV.fetch('DATABASE_URL'))
    end
  end
end
