class CommentsController < ApplicationController

  def create
    @comment = Comment.new(comment_params)
    @comment.save
  end

  def destroy
    @id = params[:id]
    @comment = Comment.find(@id)
    @comment.destroy
    respond_to do |format|
      format.js
      format.html do
        flash[:success] = "Micropost deleted"
        redirect_to request.referrer || root_url
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:msg, :user_id, :micropost_id)
  end

end
