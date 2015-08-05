class User < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order (:list_order) }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id

  has_secure_password
  validates_presence_of :email, :name

  def normalise_queue
    queue_items.each_with_index do  |queue_item, index|
      queue_item.update_attributes(list_order: index +1)
    end
  end

  def video_is_queued?(video)
    videos_in_queue = queue_items.map(&:video)
    if videos_in_queue.include?(video)
      true
    else
      false
    end
  end

  def can_follow?(other_user)
    if following_relationships.map(&:leader).include?(other_user) || other_user == self
      false
    else
      true
    end
  end

end