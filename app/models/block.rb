class Block < ApplicationRecord
  belongs_to :user
  belongs_to :blocked, class_name: "User", foreign_key: :blocked_id

  after_create do
    if user.following?(blocked)
      user.unfollow(blocked)
    end
  end
end
