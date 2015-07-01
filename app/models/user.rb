class User < ActiveRecord::Base
  has_many :reviews, -> { order(created_at: :desc) }
  has_many :queue_items
  has_secure_password
  validates_presence_of :email, :name
end