class Category < ActiveRecord::Base
  
  has_many :videos, -> {order(created_at: :desc)}

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true

 
  RECENT_VIDEOS_COUNT = 6
  def recent_videos
    videos.first(RECENT_VIDEOS_COUNT)
  end

end
