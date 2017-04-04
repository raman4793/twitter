class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.save
  end

  private
  def comment_params
    params.require(:comment).permit(:msg, :user_id, :micropost_id)
  end

end
