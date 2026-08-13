collection @jury_categories

attributes :id

node(:title) do |category|
  category.localized_title(@content_locale)
end

node(:icon_url) do |category|
  category.icon.url(:display)
end

child :active_jury_members => :members do
  attributes :id, :name

  node(:title) do |member|
    member.localized_title(@content_locale)
  end

  node(:occupation) do |member|
    member.localized_occupation(@content_locale)
  end

  node(:photo_url) do |member|
    member.photo.url(:display)
  end
end
