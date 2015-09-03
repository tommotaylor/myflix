class VideoDecorator < Draper::Decorator

  delegate_all

  def rating
    object.average_rating.present? ? "#{object.average_rating}/5.0" : "No rating"
  end
end