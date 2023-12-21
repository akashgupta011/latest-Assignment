# ImageUploader
# This uploader class defines the configuration and processing for images using CarrierWave and MiniMagick.

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Use the file storage backend
  storage :file

  # Define versions for thumbnail and preview images
  version :thumbnail do
    process resize_to_fit: [100, 100]
  end

  version :preview do
    process resize_to_fit: [300, 300]
  end

  # Define the storage directory structure
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Define the allowed file extensions
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
