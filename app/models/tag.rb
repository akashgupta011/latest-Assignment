# Tag
# This model represents a tag associated with posts. It has a many-to-many association with posts.

class Tag < ApplicationRecord
  # Associations
  has_and_belongs_to_many :posts

  # Validations
  validates :name, presence: true
end
