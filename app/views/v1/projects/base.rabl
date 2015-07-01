attributes :id,
           :title,
           :county

child :contestants => :contestants do
  attributes :id, :name
end

child(:category) { attributes :name }
