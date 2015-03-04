class Video < ActiveRecord::Base
  belongs_to :category, ->{order("title")}

  validates :title, presence: true, uniqueness: true
  validates_presence_of :description
end