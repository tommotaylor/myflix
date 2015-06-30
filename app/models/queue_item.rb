class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :video_id, :user_id
  validates_uniqueness_of :video_id

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review = Review.where(video_id: video.id, user_id: user.id).first
    review.rating if review
  end

end