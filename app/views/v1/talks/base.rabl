attributes :title,
           :description,
           :location,
           :date

child :user do
  attributes :first_name, :last_name, :email_md5, :job
end
