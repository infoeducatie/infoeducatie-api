object @current

attributes :stats, :is_logged_in, :registration

child(:edition) do
  attributes :id, :year, :name, :motto
end

child(:user) do
  attributes :id, :email, :access_token, :name
end
