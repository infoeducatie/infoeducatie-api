class Ckeditor::Asset < ActiveRecord::Base
  self.table_name = "ckeditor_assets"

  belongs_to :assetable, polymorphic: true, optional: true

  delegate :url, :current_path, :content_type, to: :data

  validates :data, presence: true

  before_validation :capture_file_metadata, if: :pending_data_upload?

  def filename
    data_file_name
  end

  def size
    data_file_size
  end

  def url_content
    url
  end

  private

  def pending_data_upload?
    data.file.present? && (new_record? || will_save_change_to_data_file_name?)
  end

  def capture_file_metadata
    self.data_file_size = data.file.size
    self.data_content_type = data.file.content_type
  end

  public

  rails_admin do
    navigation_label "Editor media"

    list do
      field :data_file_name
      field :data_content_type
      field :data_file_size
      field :type
      field :created_at
    end
  end
end
