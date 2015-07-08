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
    current_user.normalise_queue
    redirect_to my_queue_path
  end

  def update_list_order
    update_queue_items
    update_rating
    current_user.normalise_queue
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Sorry, you must enter a whole number"
  ensure
    redirect_to my_queue_path
  end

private

  def bottom_of_list
    current_user.queue_items.count + 1
  end

  def is_already_in_queue?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do  |data|
        queue_item = QueueItem.find(data["id"])
        queue_item.update_attributes!(list_order: data["list_order"]) if queue_item.user_id == current_user.id
      end
    end
  end

  def update_rating
    params[:rating].each do |data|
      queue_item = QueueItem.find(data["id"])
      review = queue_item.user_review
      review.update_attributes!(rating: data["rating"])
    end
  end
end