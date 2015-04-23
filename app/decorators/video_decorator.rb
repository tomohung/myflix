class VideoDecorator < Draper::Decorator

  delegate_all
  
  def rating
    "Rating: " + (object.rating.present? ? "#{object.rating}/5.0" : "NA")
  end

end
