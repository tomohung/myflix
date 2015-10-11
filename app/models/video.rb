class Video < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name ['myflix', Rails.env].join('_')

  belongs_to :category
  has_many :reviews, ->{order(created_at: :desc)}

  validates :title, presence: true, uniqueness: true
  validates_presence_of :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where('title LIKE ?', "%#{search_term}%").order(created_at: :desc)
  end
 
  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end

  def self.search(query, options = {})
    search_definition = {
      query: {
        multi_match: {
          query: query,
          fields: ["title^100", "description^50"],
          operator: "and"
        }
      }
    }
    if query.present? && options[:review]
      search_definition[:query][:multi_match][fields] << "reviews.body"
    end

    __elasticsearch__.search(search_definition)
  end

  def as_indexed_json(options={})
    as_json(
      only: [:title, :description],
      include: { 
        reviews: { only: [:body] }
      }
    )
  end
end
