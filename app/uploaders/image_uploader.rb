class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  version :thumb do
    process resize_to_fit: [100, 100]
  end

  version :preview do
    process resize_to_fit: [300, 300]
  end
  
  storage :file
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

end
