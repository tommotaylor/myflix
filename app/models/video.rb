class Video < ActiveRecord::Base
  
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  belongs_to :category
  has_many :reviews, -> { order(created_at: :desc) }
  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader


  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    Video.where("title LIKE ?", "%#{search_term}%").order(created_at: :desc)
  end

  def average_rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end

  def as_indexed_json(options={})
    as_json(only: 'title')
  end
end

