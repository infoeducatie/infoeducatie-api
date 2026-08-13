collection @sponsor_tiers

attributes :id

node(:title) do |tier|
  tier.localized_name(@content_locale)
end

child :active_sponsors => :sponsors do
  attributes :id, :title, :website_url

  node(:image_url) do |sponsor|
    sponsor.image.url(:display)
  end
end
