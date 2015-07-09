class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates_presence_of :rating, :body
  validates :rating, :numericality => { :greater_than => 0, :less_than_or_equal_to => 5 }
end