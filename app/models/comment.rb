class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  
  self.per_page = 10

  validates :author, presence: true
  validates :content, presence: true
  validates :posteddate, presence: true
end
