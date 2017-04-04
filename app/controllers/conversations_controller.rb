class ConversationsController < ApplicationController
  before_action :logged_in_user

  def index
    @conversations = current_user.conversations
  end

  def show
    @conversation = Conversation.find(params[:id])
  end

  def create
    @conversation = Conversation.new(conversations_param)
    @conversation.save
    redirect_to conversations_path
  end

  private
  def conversations_param
    params.require(:conversation).permit(:sender_id, :recipient_name)
  end
end
