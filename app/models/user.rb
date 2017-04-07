class User < ApplicationRecord

  mount_uploader :dp, PictureUploader
  attr_accessor :remember_token, :activation_token
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
           foreign_key: "follower_id",
           dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
           foreign_key: "followed_id",
           dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :likes, dependent: :destroy
  has_many :user_logins, dependent: :destroy


  has_many :events, as: :eventable
  has_many :events, dependent: :destroy

  has_many :events, as: :eventable, dependent: :destroy

  has_many :comments, dependent: :destroy

  has_many :conversations, foreign_key: :sender_id, dependent: :destroy

  has_many :blocks

  has_many :reports

  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  validates :uname, presence: true
  UNAME_REGEX = /\w+/
  validates :uname, uniqueness: true, format: {with: UNAME_REGEX}


  has_many :users_microposts, dependent: :destroy

  has_many :mentioners, through: :users_microposts, class_name: 'Micropost'

  after_create do
    Event.create(user: self, eventable: self, msg: 'joined μBlogger')
  end

  before_destroy do
    Event.create(user: self, eventable: self, msg: 'quit μBlogger')
  end

  def type
    'User'
  end

  def get_type
    name
  end

  def get_events
    Event.where(user_id: id)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  # Returns a user's status feed.
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  def following?(other_user)
    following.include?(other_user)
  end

  def get_followable
    puts("Getting follow suggestions")
    followings = self.following.pluck(:id)
    if followings.any?
    else
      followings = id
    end
    followable = User.where('id NOT IN (?) AND id != ?',followings,id)
  end

  def notifications
    id = followers.pluck(:id)
    Event.where(user_id: id).order(created_at: :desc)
  end

  def new_notifications
    id = followers.pluck(:id)
    Event.where("user_id IN (?) AND created_at >= ? ", id, last_logout_at).limit(20).order(created_at: :desc)
  end

  def get_conversations()
    sent = Conversation.where({sender_id: id})
    recieved = Conversation.where({recipient_id: id})
    sent.or(recieved)
  end

  def blocked?(user)
    !blocks.find_by(blocked_id: user.id).nil?
  end


  def likes?(post)
    like = likes.where(likeable: post)
    !like.empty?
  end

  def send_message(to, msg)
    conversation = Conversation.where({sender: self, recipient: to}).first
    if conversation.nil?
      conversation = Conversation.where({sender: to, recipient: self}).first
    end
    if conversation.nil?
      conversation = Conversation.create({sender: self, recipient: to})
    end
    conversation.messages.create(msg: msg)
  end

  def get_messages(from)
    conversation = Conversation.where({sender: self, recipient: from}).first
    if conversation.nil?
      conversation = Conversation.where({sender: from, recipient: self}).first
    end
    if conversation.nil?
      nil
    else
      conversation.messages
    end
  end

  def self.search(search_param)
    if search_param
      where('name LIKE ?', "%#{search_param}%")
    else
      all
    end
  end

end