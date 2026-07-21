require "rails_helper"
require "base64"
require "tempfile"

RSpec.describe "RailsAdmin editor", type: :request do
  let(:admin) { create(:admin_user) }

  after do
    Array(@temporary_uploads).each(&:close!)
  end

  describe "POST /internal/admin/editor_images" do
    it "rejects unauthenticated uploads" do
      post admin_editor_images_path,
        params: {image: uploaded_png},
        headers: {"ACCEPT" => "application/json"}

      expect(response).to have_http_status(:unauthorized)
    end

    it "rejects authenticated non-admin uploads" do
      sign_in create(:confirmed_user)

      post admin_editor_images_path,
        params: {image: uploaded_png},
        headers: {"ACCEPT" => "application/json"}

      expect(response).to have_http_status(:forbidden)
    end

    it "stores an admin image and returns its URL" do
      sign_in admin

      post admin_editor_images_path,
        params: {image: uploaded_png},
        headers: {"ACCEPT" => "application/json"}

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include(
        "filename" => "editor-image.png",
        "url" => a_string_matching(%r{/uploads/ckeditor/pictures/})
      )

      picture = Ckeditor::Picture.last
      expect(picture).to have_attributes(
        data_content_type: "image/png",
        data_file_size: 68,
        width: 1,
        height: 1
      )
    end
  end

  describe "GET /internal/admin/news/:id/edit" do
    it "renders the maintained rich-text editor" do
      sign_in admin
      news = create(:news)

      get "/internal/admin/news/#{news.id}/edit"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("<trix-editor")
      expect(response.body).to include('/internal/admin/editor_images')
    end
  end

  def uploaded_png
    file = Tempfile.new(["editor-image", ".png"])
    (@temporary_uploads ||= []) << file
    file.binmode
    file.write(
      Base64.decode64(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
      )
    )
    file.rewind
    Rack::Test::UploadedFile.new(file.path, "image/png", original_filename: "editor-image.png")
  end
end
