class User < ApplicationRecord

  # constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  # relations
  has_secure_password

  # validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  # callbacks
  before_save do
    email.downcase!
  end
end
