class QueueItemsController < ApplicationController

before_action :require_user

  def create
    queue_item = QueueItem.new(params.require(:queue_item).permit(:video_id, :user_id, :list_order))
    queue_item.save
    redirect_to home_path
  end

  def index
    @queue_items = QueueItem.all
  end

end