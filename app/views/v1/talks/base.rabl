attributes :title,
           :description,
           :location,
           :date,
           :discourse_url

child :users do
  attributes :first_name, :last_name, :email_md5, :job
end
