module V1
  class PhotoAlbumsController < ApiController
    def index
      @photo_albums = PhotoAlbum.active.ordered
    end
  end
end
