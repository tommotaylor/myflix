class QueueItemsController < ApplicationController

before_action :require_user

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(user_id: current_user.id, video_id: video.id)
    redirect_to my_queue_path
  end

  def index
    @queue_items = current_user.queue_items
  end

end