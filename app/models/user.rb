class User < ActiveRecord::Base

  has_secure_password validations: false
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_many :reviews, ->{order(created_at: :desc)}
  has_many :queue_items, ->{order(:position)}
  has_many :following_relationships, class_name: 'Relationship', foreign_key: :follower_id
  has_many :leading_relationships, class_name: 'Relationship', foreign_key: :leader_id
  def queue_include?(video)
    queue_items.map(&:video).include?(video)
  end

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update(position: index + 1)
    end
  end

end
