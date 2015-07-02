object @current

attributes :stats, :is_logged_in

child :edition do
  attributes :id, :year, :name, :motto
end

child :registration => :registration do
  attributes :has_contestant, :has_projects, :has_pending_project, :pending_project_title

  child :projects do |project|
    attributes :id, :title, :finished
  end
end

child :user do
  attributes :id, :email, :access_token, :name
end
