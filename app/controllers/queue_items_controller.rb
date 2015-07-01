class QueueItemsController < ApplicationController

before_action :require_user

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(user_id: current_user.id, video_id: video.id, list_order: bottom_of_list) unless is_already_in_queue?(video)
    redirect_to my_queue_path
  end

  def index
    @queue_items = current_user.queue_items
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.delete if current_user.queue_items.include?(queue_item)
    redirect_to my_queue_path
  end

private

  def bottom_of_list
    current_user.queue_items.count + 1
  end

  def is_already_in_queue?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

end