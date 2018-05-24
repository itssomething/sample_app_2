class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, presence: true, length: {maximum: Settings.name_max}
  validates :email, presence: true, length: {maximum: Settings.email_max},
    format: { with: VALID_EMAIL_REGEX },
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.password_min}

  before_save :email_downcase

  has_secure_password

  def email_downcase
    self.email = email.downcase!
  end
end
