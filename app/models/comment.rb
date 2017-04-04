class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost

  has_many :events, as: :eventable
  has_many :likes, as: :likeable

  has_many :events, as: :eventable

  def type
    'Comment'
  end

  def get_type
    ''
  end

  def get_likes
    likes.count
  end

  after_create do
    Event.create(user: user, eventable: micropost, msg: 'commented on a')
  end
end
