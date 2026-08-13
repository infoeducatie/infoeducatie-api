attributes :discourse_url,
           :comments_count

node(:title) do |talk|
  talk.localized_title(@content_locale)
end

node(:description) do |talk|
  talk.localized_description(@content_locale)
end

child :users do
  attributes :name, :email_md5

  node(:job) do |user|
    user.localized_job(@content_locale)
  end
end
