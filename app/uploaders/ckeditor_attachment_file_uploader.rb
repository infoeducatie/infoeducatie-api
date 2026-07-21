class CkeditorAttachmentFileUploader < CarrierWave::Uploader::Base
  ALLOWED_EXTENSIONS = %w[doc docx xls xlsx odt ods pdf zip].freeze
  MAX_FILE_SIZE = 10.megabytes

  if Rails.env.test?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "uploads/ckeditor/attachments/#{model.id}"
  end

  def extension_allowlist
    ALLOWED_EXTENSIONS
  end

  def size_range
    1.byte..MAX_FILE_SIZE
  end

end
