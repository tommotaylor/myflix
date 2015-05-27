class QueueItemsController < ApplicationController

before_action :require_user

  def index
    @queue_items = QueueItem.all
  end

end