class User < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items, -> { order (:list_order) }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :invites
  has_many :payments

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

  def follow(user)
    Relationship.create(follower: self, leader: user) if can_follow?(user)
  end

  def deactivate!
    self.update_attributes!(account_status: false)
  end

  def active?
    account_status == true
  end
end