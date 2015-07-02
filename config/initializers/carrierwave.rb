CarrierWave.configure do |config|

  config.fog_credentials = {
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['AWS_S3_KEY'],
    :aws_secret_access_key => ENV['AWS_S3_SECRET'],
    :region                => ENV['AWS_S3_REGION']
  } if ENV['AWS_S3_KEY']

  config.fog_directory  = ENV['AWS_S3_BUCKET']
  config.fog_public = true

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"
end
