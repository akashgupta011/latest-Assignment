class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_one_attached :image

  self.per_page = 10
  mount_uploader :image, ImageUploader
  after_save :process_images
  
  validates :title, presence: true
  validates :content, presence: true
  validates :author, presence: true
  validates :published_date, presence: true

  def process_images
    return unless image.attached?

    # Create a thumbnail (100x100)
    image.variant(resize: '100x100').processed

    # Create a preview (300x300)
    image.variant(resize: '300x300').processed
  end
  
end