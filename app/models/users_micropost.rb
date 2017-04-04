class UsersMicropost < ApplicationRecord
  belongs_to :mentioned, class_name: 'User', foreign_key: "user_id"
  belongs_to :mentioner, class_name: 'Micropost', foreign_key: "micropost_id"

  def type
    'Mention'
  end

  def get_type
    mentioned.name
  end

  after_create do
    Event.create(user: mentioned, eventable: mentioner, msg: 'mentioned in a μBlog')
  end

end
