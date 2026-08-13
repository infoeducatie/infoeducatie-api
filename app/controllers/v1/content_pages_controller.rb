module V1
  class ContentPagesController < ApiController
    def show
      @content_page = ContentPage.active.find_by(slug: params[:slug])
      head :not_found unless @content_page
    end
  end
end
