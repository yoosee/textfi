class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save {
    self.email = email.downcase
  }
  before_create :create_remember_token

  validates :name, presence: true, length: { naximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, lenght: { minimum: 6 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt token
    Digest::SHA1.hexdigest token.to_s
  end

end
