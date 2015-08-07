attributes :id,
           :title,
           :counties,
           :discourse_url,
           :comments_count

if root_object.edition.show_results == true
  attributes :score,
             :extra_score,
             :total_score,
             :prize
end

child :contestants => :contestants do
  attributes :id, :name, :county, :school_name
end

node :category do |u|
  u.category.name
end
