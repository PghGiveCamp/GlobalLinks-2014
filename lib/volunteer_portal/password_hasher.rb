module VolunteerPortal
  class PasswordHasher
    def initialize(options = {})
      @salt = options.fetch(:salt)
    end

    def hash_password(password)
      Digest::SHA512.hexdigest("#{salt}:#{password}")
    end

    private

    attr_accessor :salt
  end
end
