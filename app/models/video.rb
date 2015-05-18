class Video < ActiveRecord::Base
  belongs_to :category

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    results = Video.where("title LIKE ?", "%#{search_term}%")
  end

end
