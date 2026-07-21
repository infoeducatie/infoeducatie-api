require 'carrierwave/storage/fog'

CarrierWave.configure do |config|

  config.fog_credentials = {
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['AWS_S3_KEY'],
    :aws_secret_access_key => ENV['AWS_S3_SECRET'],
    :region                => ENV['AWS_S3_REGION']
  } if ENV['AWS_S3_KEY']

  if ENV['AWS_S3_HOST']
    asset_host = ENV['AWS_S3_HOST']
    asset_host = asset_host.sub(/\Ahttp:\/\//i, 'https://') if Rails.env.production?
    config.asset_host = asset_host
  end
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
