require 'carrierwave/orm/activerecord'

class Screenshot < ActiveRecord::Base
  PREVIEWABLE_EXTENSIONS = %w(bmp gif jfif jpeg jpg png webp).freeze

  belongs_to :project
  validates :project, presence: true

  mount_uploader :screenshot, ScreenshotUploader
  validates_presence_of :screenshot

  after_save :update_project_discourse
  after_destroy :update_project_discourse

  def update_project_discourse
    return unless project && project.status == Project::STATUS_APPROVED

    project.screenshots.reset if destroyed?
    project.update_discourse
  end

  def url
    screenshot.url unless screenshot.nil?
  end

  def filename
    read_attribute(:screenshot)
  end

  def previewable?
    extension = File.extname(filename.to_s).delete('.').downcase
    PREVIEWABLE_EXTENSIONS.include?(extension)
  end

  rails_admin do
    configure :screenshot, :carrierwave do
      pretty_value do
        bindings[:view].render(
          partial: "rails_admin/main/screenshot_gallery",
          locals: { screenshots: [bindings[:object]] }
        )
      end
    end

    list do
      field :screenshot do
        column_width 260
      end
      field :project do
        searchable :title
      end
    end
    edit do
      field :project
      field :screenshot do
        html_attributes accept: "image/jpeg,image/png,image/webp"
        help "JPEG, PNG or WebP, up to 10 MB."
      end
    end

    nested do
      field :screenshot do
        html_attributes accept: "image/jpeg,image/png,image/webp"
      end
      exclude_fields :project
    end
  end
end
