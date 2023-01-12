class User < ApplicationRecord
    has_secure_password

    validates :username, presence: true, uniqueness: { case_sensitive: false }

    #used in the auth controller
    def authenticate(password)
        if BCrypt::Password.new(self.password_digest) == password
            self
        else
            false
        end
    end
    
end
