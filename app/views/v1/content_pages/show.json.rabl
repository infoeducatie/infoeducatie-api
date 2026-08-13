object @content_page

attributes :id, :slug, :updated_at

node(:title) do |page|
  page.localized_title(@content_locale)
end

node(:body) do |page|
  page.localized_body(@content_locale)
end

node(:document_url) do |page|
  page.localized_document_url(@content_locale)
end
