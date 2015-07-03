attributes :id,
           :title,
           :body,
           :pinned,
           :created_at

node :short_description do |news|
  truncate(news.body, length: 140)
end


