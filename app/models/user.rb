class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  #search for followed_id key in relationships table
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
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
    # another rails simplification
    # following_ids is actually following.map(&:id) OR following.map{ |i| i.to_s }
    # made by Active Record based on has_many :following
    # it creates massive of id followings and users id itself
    # ? - is interpritated by SQL correctly
    # it puts our massive of ids in request

    # Micropost.where("user_id IN (?) OR user_id=?", following_ids, id)

    # version 2.0,  instead of ? we used variables
    # Micropost.where("user_id IN (:following_ids) OR user_id = :user_id",
    #            following_ids: following_ids, user_id: id)

    # and ver2.1 with SQL subrequest
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)

  end

  def follow(other_user)
    # old listing
    # active_relationships.create(followed_id: other_user.id)
    # new one
    following << other_user
  end

  def unfollow(other_user)
    # old listing
    # active_relationships.find_by(followed_id: other_user.id).destroy
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
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
