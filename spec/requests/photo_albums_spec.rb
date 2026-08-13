require "rails_helper"

RSpec.describe "Photo albums API", type: :request do
  it "returns active albums in configured display order" do
    create(:photo_album, title: "2022", title_en: "Edition 2022", position: 20)
    create(:photo_album, title: "2023", title_en: "Edition 2023", position: 10)
    create(:photo_album, title: "2024", position: 5, active: false)

    get "/v1/photo_albums.json", params: {locale: "en"}

    expect(response).to have_http_status(:ok)
    payload = JSON.parse(response.body)
    expect(payload.map { |album| album["title"] })
      .to eq(["Edition 2023", "Edition 2022"])
    expect(payload.first["external_url"])
      .to eq("https://photos.example.test/albums/2023")
    expect(payload.first["cover_image_url"])
      .to match(%r{/uploads/photo_albums/})
  end
end
