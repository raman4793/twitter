class Event < ApplicationRecord
  belongs_to :user
  belongs_to :eventable, polymorphic: true
  default_scope -> { order(created_at: :desc) }

  def self.now
    where("created_at > ? ",Time.now-1.days)
  end

  def self.yesterday
    where("created_at > ? AND created_at < ? ",Time.now-2.days,Time.now-1.days)
  end

  def self.history
    where("created_at <= ? ",Time.now-2.days)
  end
end
