class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.save
  end
  private
  def message_params
    params.require(:message).permit(:msg, :conversation_id, :user_id)
  end
end
