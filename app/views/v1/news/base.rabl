attributes :id,
           :title,
           :body,
           :pinned

node :short_description do |news|
  truncate(news.body, length: 140)
end


