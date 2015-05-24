class Review < ActiveRecord::Base
  belongs_to :video
  validates_presence_of :rating
end