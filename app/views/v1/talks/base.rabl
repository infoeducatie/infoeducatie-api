attributes :title,
           :description,
           :discourse_url,
           :comments_count

child :users do
  attributes :name, :email_md5, :job
end
