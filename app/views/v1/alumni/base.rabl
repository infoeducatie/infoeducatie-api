attributes :description

child :editions => :editions do
  attributes :name
end

child :user do
  attributes :first_name, :last_name, :email_md5
end
