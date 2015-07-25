attributes :title,
           :description,
           :discourse_url

child :users do
  attributes :name, :email_md5, :job
end
