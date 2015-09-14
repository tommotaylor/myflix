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

  def self.search(query, options={})
    search_definition =  {
      query: {  
        multi_match: {
          query: query,
          fields: ['title^100', 'description^50'],
          operator: 'and'
        }
      }
    }

    if query.present? && options[:reviews]
      search_definition[:query][:multi_match][:fields] << 'reviews.body'
    end

    if options[:rating_from].present? || options[:rating_to].present?
      search_definition[:filter] = {
        range: {
          average_rating: {
            gte:  options[:rating_from],
            lte:   options[:rating_to]
          } 
        }
      }
    end
    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(
      methods: :average_rating,
      only: [:title, :description],  
      include: { 
        reviews: { only: [:body] }
      }
    )
  end
end

