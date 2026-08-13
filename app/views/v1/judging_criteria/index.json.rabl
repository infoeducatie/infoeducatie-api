collection @judging_criteria

attributes :id

node(:title) do |criterion|
  criterion.localized_title(@content_locale)
end

node(:document_url) do |criterion|
  criterion.document.url
end
