attributes :id,
           :title,
           :county,
           :description,
           :technical_description,
           :system_requirements,
           :source_url,
           :homepage,
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
