class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, ->{order(created_at: :desc)}

  validates :title, presence: true, uniqueness: true
  validates_presence_of :description

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where('title LIKE ?', "%#{search_term}%").order(created_at: :desc)
  end
 
end
