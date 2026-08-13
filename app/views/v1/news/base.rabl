attributes :id,
           :pinned,
           :created_at

node(:title) do |news|
  news.localized_title(@content_locale)
end

node(:body) do |news|
  body = news.localized_body(@content_locale)
  if @collapse_short_news_bodies && news.localized_short(@content_locale).length < 50
    ""
  else
    body
  end
end

node(:short) do |news|
  news.localized_short(@content_locale)
end

