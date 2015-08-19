class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }
  mount_uploader :large_cover, VideoUploader
  mount_uploader :small_cover, VideoUploader


  validates_presence_of :title, :description, :category

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where("title LIKE ?", "%#{search_term}%").order(created_at: :desc)
  end

  def average_rating
    if self.reviews.any?
      Review.average(:rating).round(1)
    else
      "No reviews"
    end
  end

end

