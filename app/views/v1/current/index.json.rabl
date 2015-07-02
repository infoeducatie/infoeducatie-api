object @current

attributes :stats, :registration, :is_logged_in

child(:edition) do
  attributes :id, :year, :name, :motto
end

child(:user) do
  attributes :id, :email, :access_token, :name
end
