class Category < ActiveRecord::Base
  has_many :videos

  def recent_videos
    videos
  end

end
