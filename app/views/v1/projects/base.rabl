attributes :id,
           :title,
           :description,
           :technical_description,
           :system_requirements,
           :source_url,
           :homepage,
           :approved

child :contestants => :contestants do
  attributes :id
end
