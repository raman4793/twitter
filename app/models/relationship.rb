class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  has_many :events, as: :eventable

  validate :can_follow

  def type
    'Follow'
  end

  def get_type
    followed.name
  end

  def can_follow
    if followed.blocked?(follower)
      record.errors[:follower] << ' Cannot follow this user'
    end
  end

  after_create do
    Event.create(user: follower, eventable: followed, msg: 'followed')
  end

  before_destroy do
    Event.create(user: follower, eventable: followed, msg: 'unfollowed')
  end

end
