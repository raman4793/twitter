class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      respond_to do |format|
        format.js
        format.html do
          flash[:success] = "Micropost created!"
          redirect_to root_url
        end
      end
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @id = @micropost.id
    @micropost.destroy
    respond_to do |format|
      format.js
      format.html do
        flash[:success] = "Micropost deleted"
        redirect_to request.referrer || root_url
      end
    end
  end

  def tags
    name = params[:name].to_s
    tag = Tag.find_by(name: name.downcase)
    @posts = tag.microposts.all.paginate(page: params[:page], :per_page => 10)
  end

  def update
    @micropost = Micropost.find(params[:id])
    @micropost.update(micropost_params)
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
