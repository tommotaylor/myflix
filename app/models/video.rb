class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where("title LIKE ?", "%#{search_term}%").order(created_at: :desc)
  end

  def average_rating
    if self.reviews.any?
      ratings = self.reviews.map(&:rating)
      sum = ratings.sum
      mean = sum/ratings.count.round(1)
    else
      return "No reviews"
    end
  end

end
