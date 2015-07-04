FactoryGirl.define do
  factory :talk do
    title "MyString"
    description "MyText"

    association :edition
    association :user
  end
end
