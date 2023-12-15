class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_one_attached :image

  self.per_page = 10
  
  validates :title, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :published_date, presence: true

end