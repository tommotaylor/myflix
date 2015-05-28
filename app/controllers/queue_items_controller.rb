class QueueItemsController < ApplicationController

before_action :require_user

  def create
    queue_item = QueueItem.create(user_id: session[:user_id])
    redirect_to home_path
  end

  def index
    @queue_items = QueueItem.all
  end

end