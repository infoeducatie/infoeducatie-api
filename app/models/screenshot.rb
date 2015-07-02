require 'carrierwave/orm/activerecord'

class Screenshot < ActiveRecord::Base
  belongs_to :project

  mount_uploader :screenshot, ScreenshotUploader

end
