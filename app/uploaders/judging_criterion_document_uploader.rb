class JudgingCriterionDocumentUploader < CarrierWave::Uploader::Base
  ALLOWED_EXTENSIONS = %w[pdf].freeze
  ALLOWED_CONTENT_TYPES = %r{\Aapplication/pdf\z}.freeze
  MAX_FILE_SIZE = 10.megabytes

  if Rails.env.test? || ENV["AWS_S3_BUCKET"].blank?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/judging_criteria/#{model.id}"
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
end
