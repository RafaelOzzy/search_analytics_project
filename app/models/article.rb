class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true

  scope :search, ->(term) {
    where("title ILIKE :term OR content ILIKE :term", term: "%#{term}%")
  }
end
