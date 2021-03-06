class User < ApplicationRecord
  ################################################### accessors ########################################################
  attr_accessor :remember_token, :activation_token, :reset_token

  ################################################### constants ########################################################
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  ################################################### relations ########################################################
  has_many :microposts, dependent: :destroy
  
  #################################################### configs #########################################################
  has_secure_password

  ################################################## validations #######################################################
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 50 }, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  ################################################# before actions #####################################################
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
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # activates an account
  def activate
    self.update(activated: true, activated_at: Time.zone.now)
  end
  
  # sends activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
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

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    self.update(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    Micropost.where("user_id = ?", id)
  end
  
  private
  # before validations
  def downcase_email
    self.email.downcase!
  end
  
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(self.activation_token)
  end
end
