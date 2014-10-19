require 'sequel'
require 'volunteer_portal/password_hasher'

module Sampledata
  def load_all
    loader = Loader.new
    loader.load_users
  end

  module_function :load_all

  class Loader
    def load_users
      unless db[:users].filter(email: 'amcoder@gmail.com').first
        db[:users] << {
          username: 'amcoder',
          email: 'amcoder@gmail.com',
          volunteer_id: db[:volunteers].filter(
            preferred_email: 'amcoder@gmail.com'
          ).first.fetch(:id),
          password: hasher.hash_password('changeme')
        }
      end
    end

    private

    def hasher
      @hasher ||= VolunteerPortal::PasswordHasher.new(salt: ENV.fetch('SALT'))
    end

    def db
      @db ||= Sequel.connect(ENV.fetch('DATABASE_URL'))
    end
  end
end
