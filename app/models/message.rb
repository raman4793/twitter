class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
  validates_presence_of :msg, :conversation_id

  def message_time
    created_at.strftime("%m/%d/%y at %l:%M %p")
  end

  def recipient
    conversation.recipient
  end

  def sender
    conversation.sender
  end
end
