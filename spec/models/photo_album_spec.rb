require "rails_helper"

RSpec.describe PhotoAlbum, type: :model do
  subject(:album) { build(:photo_album, title: "Tab\u0103ra 2023") }

  it "accepts complete HTTP and HTTPS album URLs" do
    album.external_url = "https://photos.example.test/2023"
    expect(album).to be_valid

    album.external_url = "http://photos.example.test/2023"
    expect(album).to be_valid
  end

  it "rejects incomplete album URLs" do
    album.external_url = "photos.example.test/2023"

    expect(album).not_to be_valid
    expect(album.errors[:external_url]).to be_present
  end

  it "uses the Romanian title as the English fallback" do
    album.title_en = nil

    expect(album.localized_title(:en)).to eq("Tab\u0103ra 2023")
  end
end
