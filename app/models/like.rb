class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true
  has_many :events, as: :eventable

  def type
    'Like'
  end

  def get_type
    micropost.content
  end

  def self.get(user, likeable)
    Like.where(user: user, likeable: likeable).first
  end

  after_create do
    Event.create(user: user, eventable: likeable, msg: 'liked a')
  end
end
