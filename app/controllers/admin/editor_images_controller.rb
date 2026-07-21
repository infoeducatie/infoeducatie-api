module Admin
  class EditorImagesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin!

    def create
      picture = Ckeditor::Picture.new(data: params.require(:image))

      if picture.save
        render json: {
          url: picture.url_content,
          filename: picture.filename
        }, status: :created
      else
        render json: {
          error: picture.errors.full_messages.to_sentence
        }, status: :unprocessable_content
      end
    end

    private

    def require_admin!
      head :forbidden unless current_user&.admin?
    end
  end
end
