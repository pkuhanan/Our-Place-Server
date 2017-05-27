class User < ApplicationRecord
  has_secure_password
  has_secure_token
  
  validates :email, uniqueness: true, presence: true

  # This method is not available in has_secure_token
  def invalidate_token
    self.update_columns(token: nil)
  end

  def self.valid_login?(email, password)
    user = find_by(email: email)
    if user && user.authenticate(password)
      user
    end
  end
end
