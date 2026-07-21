class Ckeditor::Picture < Ckeditor::Asset
  mount_uploader :data, CkeditorPictureUploader, mount_on: :data_file_name

  before_validation :capture_image_dimensions, if: :pending_data_upload?

  def url_content
    url(:content)
  end

  private

  def capture_image_dimensions
    image = MiniMagick::Image.new(data.file.path)
    self.width = image.width
    self.height = image.height
  end

  public

  rails_admin do
    navigation_label "Editor media"

    list do
      field :data
      field :width
      field :height
      field :created_at
    end
  end
end
