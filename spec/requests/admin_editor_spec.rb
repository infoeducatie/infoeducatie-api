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

  describe "GET /internal/admin/content_page/:id/edit" do
    it "renders localized rich-text editors for a content page" do
      sign_in admin
      page = create(:content_page, slug: "about")

      get "/internal/admin/content_page/#{page.id}/edit"

      expect(response).to have_http_status(:ok)
      expect(response.body.scan("<trix-editor").length).to eq(2)
      expect(response.body).to include('/internal/admin/editor_images')
      expect(response.body.scan('accept="application/pdf"').length).to eq(2)
      expect(response.body).not_to include('name="content_page[slug]"')
      expect(response.body).not_to include('name="content_page[active]"')
    end

    it "does not expose create or delete actions for fixed content pages" do
      sign_in admin
      page = create(:content_page, slug: "about")

      get "/internal/admin/content_page"

      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include("/internal/admin/content_page/new")
      expect(response.body).not_to include(
        "/internal/admin/content_page/#{page.id}/delete"
      )

      expect do
        get "/internal/admin/content_page/new"
      end.to raise_error(RailsAdmin::ActionNotAllowed)

      expect do
        get "/internal/admin/content_page/#{page.id}/delete"
      end.to raise_error(RailsAdmin::ActionNotAllowed)
    end
  end

  describe "GET /internal/admin/blog_post/:id/edit" do
    it "renders localized rich-text editors for a blog post" do
      sign_in admin
      post = create(:blog_post)

      get "/internal/admin/blog_post/#{post.id}/edit"

      expect(response).to have_http_status(:ok)
      expect(response.body.scan("<trix-editor").length).to eq(2)
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
