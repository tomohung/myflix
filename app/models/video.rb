class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true, uniqueness: true
end