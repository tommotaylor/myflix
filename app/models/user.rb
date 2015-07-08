class User < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order (:list_order) }
  has_secure_password
  validates_presence_of :email, :name

  def normalise_queue
    queue_items.each_with_index do  |queue_item, index|
      queue_item.update_attributes(list_order: index +1)
    end
  end

end