class Ckeditor::AttachmentFile < Ckeditor::Asset
  mount_uploader :data, CkeditorAttachmentFileUploader, mount_on: :data_file_name

  def url_thumb
    nil
  end

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
