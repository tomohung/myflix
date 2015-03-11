class QueueItem < ActiveRecord::Base

  validates_presence_of :user_id, :video_id
  belongs_to :user
  belongs_to :video

  def video_title
    video.title
  end

  def category_name
    video.category.title
  end

  def category
    video.category
  end

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end
end