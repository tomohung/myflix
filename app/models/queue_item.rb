class QueueItem < ActiveRecord::Base

  validates_presence_of :user, :video
  validates_numericality_of :position, {only_integer: true}
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.title
  end

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end

  def self.append_video_to_user(user, video)
      queue_item = QueueItem.new(user: user, video: video)
      queue_item.position = user.queue_items.count + 1
      queue_item.save
  end

end