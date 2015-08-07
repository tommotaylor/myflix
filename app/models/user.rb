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
    queue_items.map(&:video).include?(video)
  end

  def can_follow?(other_user)
    !(following_relationships.map(&:leader).include?(other_user) || other_user == self)
  end

  def send_password_reset
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.now
    save!
    AppMailer.reset_password(self).deliver
  end

  def invalidate_token
    self.password_reset_token = SecureRandom.urlsafe_base64
    save!   
  end
end