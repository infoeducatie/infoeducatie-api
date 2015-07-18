object @current

attributes :stats, :is_logged_in

child :edition do
  attributes :id, :year, :name, :motto, :projects_count,
  :counties_count, :contestants_count, :count,
  :registration_start_date, :registration_end_date, :travel_data_deadline
end

child :registration => :registration do
  child :pending_project => :pending_project do
    attributes :id, :title, :screenshots_count
  end

  child :finished_projects => :finished_projects do |project|
    attributes :id, :title, :finished
  end
end

child :user do
  attributes :id, :email, :access_token, :name, :registration_step_number
end
