class Screenshot < ActiveRecord::Base
  belongs_to :project

  mount_uploader :screenshot, ScreenshotUploader

  rails_admin do
    list do
      field :name
      field :school_name
    end
  end

end
