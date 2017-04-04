class BlocksController < ApplicationController

  def create
    @block = current_user.blocks.build(block_params)
    @block.save
  end

  def destroy
    @block = current_user.blocks.find(params[:id])
    @block.destroy
  end

  private

  def block_params
    params.require(:block).permit(:user_id, :blocked_id, :reason)
  end
end
