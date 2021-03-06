class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates_numericality_of :list_order, { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review = Review.find_by(video_id: video.id, user_id: user.id)
    review.rating if review
  end

  def rating=(new_rating)
      review = Review.find_by(video_id: video.id, user_id: user.id)
    if review
      review.update(rating: new_rating)
    else
      review = Review.create(rating: new_rating, body: "This review has no content", video_id: video.id, user_id: user.id)
    end
  end

  def user_review
    review = Review.find_by(video_id: video.id, user_id: user.id)
  end


end

