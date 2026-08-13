collection @blog_posts

attributes :id, :slug, :author_name, :published_at, :updated_at

node(:title) do |post|
  post.localized_title(@content_locale)
end

node(:excerpt) do |post|
  post.localized_excerpt(@content_locale)
end

node(:category) do |post|
  post.localized_category(@content_locale)
end
