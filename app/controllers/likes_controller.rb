class LikesController < ApplicationController
  def create
    @like = Like.new(like_params)
    @like.save
    @id=@like.likeable.id
    respond_to do |format|
      format.js
      format.html {redirect_to root_url}
    end
  end
  def destroy
    @like = Like.find(params[:id])
    @likeable = @like.likeable
    @like.destroy
    respond_to do |format|
      format.js
      format.html {redirect_to root_url}
    end
  end
  private
  def like_params
    params.require(:like).permit(:user_id, :likeable_id, :likeable_type)
  end
end
