FactoryBot.define do
  sequence :edition_name do |n|
    "200#{n}"
  end

  factory :edition, class: Edition do
    year { 2015 }
    name { generate(:edition_name) }
    camp_start_date { "2015-06-28" }
    camp_end_date { "2015-06-28" }
    motto { "MyString" }
    registration_start_date { 1.day.ago }
    registration_end_date { 1.day.from_now }
    travel_data_deadline { "2015-06-28" }
    published { true }
    current { true }
    projects_forum_category { "Lucrari 2015 Nationala" }
    talks_forum_category { "Prezentari 2015 Nationala" }
  end
end
