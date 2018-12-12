class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  #changed from {self.email=email.downcase}
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
          format: {with: VALID_EMAIL_REGEX},
          uniqueness: { case_sensitive: false}
  has_secure_password
  validates :password, length: { minimum: 6 }, allow_blank: true

  #Digest
  def User.digest(string)
   cost=ActiveModel::SecurePassword.min_cost ?
     BCrypt::Engine::MIN_COST :
     BCrypt::Engine.cost

   BCrypt::Password.create(string, cost: cost)
  end

  #cookies token
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token= User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

# new method, works for remember and activated tokens

  def authenticated?(attribute, token)
    digest=send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
    # Using Bcrypt you can also write BCrypt::Password.new(remember_digest)==remember_token
    # remember_token here is not remember_token from attr_accessor
    # its local method variable
    # remember_digest here is automaticaly user.remember_digest
    # send here is auto changed from self.send
    # created by Active Record
  end

# cookies hash delete
  def forget
    update_attribute(:remember_digest, nil)
  end

# activate account
  def activate
# can skip self inside user model
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

# send email with activation link
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

# create attributes for password change
  def create_reset_digest
    self.reset_token=User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

# sent reset password email
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

# proto feed
  def feed
    Micropost.where("user_id=?", id)
  end


  private

# changes email to downcase
  def downcase_email
    self.email=email.downcase
  end

# create activation token and digest
  def create_activation_digest
    self.activation_token=User.new_token
    self.activation_digest=User.digest(activation_token)
  end

end
