class User < ApplicationRecord

  # constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

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
  
  # other methods
  # returns the hash digest of the given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST  : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # return a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
