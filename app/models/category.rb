class Category < ActiveRecord::Base

  has_many :videos, -> { order(created_at: :desc) }

  def recent_videos
    videos
  end

end
