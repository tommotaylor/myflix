class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :video_id, :user_id
  validates_uniqueness_of :video_id
end