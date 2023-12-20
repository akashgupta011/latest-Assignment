# Category
# This model represents a category for posts. It has a many-to-many association with posts.

class Category < ApplicationRecord
  # Associations
  has_and_belongs_to_many :posts

  # Validations
  validates :name, presence: true
end
