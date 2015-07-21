require 'carrierwave/orm/activerecord'

class Screenshot < ActiveRecord::Base
  belongs_to :project
  validates :project, presence: true

  mount_uploader :screenshot, ScreenshotUploader
  validates_presence_of :screenshot

  def url
    screenshot.url unless screenshot.nil?
  end

  rails_admin do
    list do
      field :project
    end
    edit do
      field :project
      field :screenshot
    end
  end
end
