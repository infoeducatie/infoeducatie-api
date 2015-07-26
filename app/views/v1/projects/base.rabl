attributes :id,
           :title,
           :county,
           :discourse_url,
           :comments_count

if root_object.edition.show_results == true
  attributes :score,
             :extra_score,
             :total_score,
             :prize
end

child :contestants => :contestants do
  attributes :id, :name
end

node :category do |u|
  u.category.name
end

node :discourse_comments_count do 0 end
