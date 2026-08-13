node(:description) do |alumnus|
  alumnus.localized_description(@content_locale)
end

child :editions => :editions do
  attributes :name
end

child :user do
  attributes :first_name, :last_name, :email_md5

  node(:job) do |user|
    user.localized_job(@content_locale)
  end
end
