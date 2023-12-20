# Post
# This model represents a post created by a user. It includes associations with comments,
# categories, and tags, as well as an attached image. Additionally, it defines validations for
# required attributes and handles image processing.

class Post < ApplicationRecord

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_one_attached :image

  # Pagination
  self.per_page = 10

  # Image Uploader Configuration
  mount_uploader :image, ImageUploader

  # Callbacks
  after_save :process_images

  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :published_date, presence: true

  # Public: Returns the URL of the attached image.
  #
  # Returns a String containing the image URL or nil if no image is attached.
  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  mapping do
    indexes :title, type: 'text'
    indexes :content, type: 'text'
    # Add more indexes for categories and tags as needed
  end

  def as_indexed_json(_options = {})
    as_json(only: %w[title content])
  end

  private

  # Private: Process images after saving the post.
  #
  # Returns nothing.
  def process_images
    return unless image.attached?

    # Create a thumbnail (100x100)
    image.variant(resize: '100x100').processed

    # Create a preview (300x300)
    image.variant(resize: '300x300').processed
  end
end
