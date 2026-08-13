FactoryBot.define do
  sequence :photo_album_title do |number|
    "Photo album #{number}"
  end

  factory :photo_album do
    title { generate(:photo_album_title) }
    title_en { "English #{title}" }
    external_url { "https://photos.example.test/albums/#{title.parameterize}" }
    cover_image do
      Rack::Test::UploadedFile.new(
        Rails.root.join("db", "seed_assets", "photo_albums", "covers", "2023.jpg"),
        "image/jpeg"
      )
    end
    position { 10 }
    active { true }
  end
end
