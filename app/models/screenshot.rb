require 'carrierwave/orm/activerecord'

class Screenshot < ActiveRecord::Base
  belongs_to :project
  validates :project, presence: true

  mount_uploader :screenshot, ScreenshotUploader
  validates_presence_of :screenshot

  after_create :update_project_discourse
  def update_project_discourse
      project.update_discourse if project.status == Project::STATUS_APPROVED
  end

  def url
    screenshot.url unless screenshot.nil?
  end

  rails_admin do
    list do
      field :project do
        searchable :title
      end
    end
    edit do
      field :project
      field :screenshot
    end
  end
end
