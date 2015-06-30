FactoryGirl.define do
  factory :edition, class: Edition do
    year 2015
    name "MyString"
    camp_start_date "2015-06-28"
    camp_end_date "2015-06-28"
    motto "MyString"
    registration_start_date "2015-06-28 01:46:03"
    registration_end_date "2015-06-28 01:46:03"
    travel_data_deadline "2015-06-28"
    published true
    current true
  end
end
