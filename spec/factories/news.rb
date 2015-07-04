FactoryGirl.define do
  factory :news do
    title "MyString"
    body "20 characters they say you have to have here"
    pinned false
    association :edition
  end
end
