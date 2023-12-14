class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_one_attached :image

  validates :title, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :published_date, presence: true
  self.per_page = 10
end