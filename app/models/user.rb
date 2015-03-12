class User < ActiveRecord::Base

  has_secure_password validations: false
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email

  has_many :reviews
  has_many :queue_items

  def queue_include?(video)
    queue_items.map(&:video).include?(video)
  end

end
