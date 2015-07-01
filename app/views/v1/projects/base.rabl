attributes :id,
           :title,
           :county

child :contestants => :contestants do
  attributes :id, :name
end

node :category do |u|
  u.category.name
end

node :discourse_id do 0 end
node :discourse_comments_no do 0 end
