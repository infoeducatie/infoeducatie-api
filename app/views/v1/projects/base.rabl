attributes :id,
           :title,
           :county,
           :discourse_url

child :contestants => :contestants do
  attributes :id, :name
end

child :screenshots => :screenshots do
  attributes :url
end

node :category do |u|
  u.category.name
end

node :discourse_comments_count do 0 end
