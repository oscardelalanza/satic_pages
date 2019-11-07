class User < ApplicationRecord
  # accessors
  attr_accessor :remember_token, :activation_token

  # constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  # relations
  has_secure_password

  # validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # before actions
  before_save :downcase_email
  before_create :create_activation_digest
  
  
  # instance methods
  # set a remember token on the database
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # forget a remember token from the data base
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # returns true of the given token matches the digest
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end
  
  # class methods
  # returns the hash digest of the given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # return a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  private
  
  def downcase_email
    self.email.downcase!
  end
  
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(self.activation_token)
  end
end
