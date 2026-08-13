class JuryIconUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  ALLOWED_EXTENSIONS = %w[jpeg jpg png webp].freeze
  ALLOWED_CONTENT_TYPES = %r{\Aimage/(jpeg|png|webp)\z}.freeze
  MAX_FILE_SIZE = 2.megabytes

  if Rails.env.test? || ENV["AWS_S3_BUCKET"].blank?
    storage :file
  else
    storage :fog
  end

  process :strip_metadata

  version :display do
    process resize_to_limit: [100, 70]
  end

  def store_dir
    "uploads/jury_categories/#{model.id}/icon"
  end

  def extension_allowlist
    ALLOWED_EXTENSIONS
  end

  def content_type_allowlist
    ALLOWED_CONTENT_TYPES
  end

  def size_range
    1.byte..MAX_FILE_SIZE
  end

  private

  def strip_metadata
    manipulate! do |image|
      image.strip
      image
    end
  end
end
