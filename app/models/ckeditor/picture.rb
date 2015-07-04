class Ckeditor::Picture < Ckeditor::Asset
  mount_uploader :data, CkeditorPictureUploader, :mount_on => :data_file_name

  def url_content
    url(:content)
  end

  rails_admin do
    list do
      field :data
      field :width
      field :height
      field :created_at
    end
  end
end
