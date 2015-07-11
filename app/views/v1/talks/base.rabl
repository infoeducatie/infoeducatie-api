attributes :title,
           :description,
           :location,
           :date,
           :discourse_url

child :users do
  attributes :name, :email_md5, :job
end
