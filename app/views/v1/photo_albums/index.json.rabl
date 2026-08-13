collection @photo_albums

attributes :id, :external_url

node(:title) do |album|
  album.localized_title(@content_locale)
end

node(:cover_image_url) do |album|
  album.cover_image.url(:display)
end
