# Comment
# This model represents a comment made by a user on a post.

class Comment < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :post

  # Pagination
  self.per_page = 10

  # Validations
  validates :author, presence: true
  validates :content, presence: true
  validates :posteddate, presence: true
end
