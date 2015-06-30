class QueueItemsController < ApplicationController

before_action :require_user

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(user_id: current_user.id, video_id: video.id, list_order: bottom_of_list)
    redirect_to my_queue_path
  end

  def index
    @queue_items = current_user.queue_items
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.delete
    redirect_to my_queue_path
  end

private

  def bottom_of_list
    current_user.queue_items.count + 1
  end

end