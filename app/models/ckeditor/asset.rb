class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase

  delegate :url, :current_path, :content_type, :to => :data

  validates_presence_of :data

  rails_admin do
    list do
      field :data_file_name
      field :data_content_type
      field :data_file_size
      field :type
      field :created_at
    end
  end
end
