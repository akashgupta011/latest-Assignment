class Post < ApplicationRecord
  belongs_to :user
  
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  has_one_attached :image

  self.per_page = 10
  mount_uploader :image, ImageUploader
  # after_save :process_images
  
  validates :title, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :published_date, presence: true

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
  # def process_images
  #   return unless image.attached?

  #   # Create a thumbnail (100x100)
  #   image.variant(resize: '100x100').processed

  #   # Create a preview (300x300)
  #   image.variant(resize: '300x300').processed
  # end
  
end