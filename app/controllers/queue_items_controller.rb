class QueueItemsController < ApplicationController

before_action :require_user

  def create
    video = Video.find(params[:video_id])
    queue_item = QueueItem.create(user_id: current_user.id, video_id: video.id)
    if queue_item.save
      redirect_to 'my_queue'
    else
      flash[:error] = "Sorry that didn't save"
      render 'queue_items/index'
    end
  end

  def index
    @queue_items = QueueItem.where(user_id: current_user.id)
  end

end