FactoryGirl.define do
  factory :talk do
    title "MyString"
    description "MyText"
    association :edition
    users { build_list(:user, 1) }
  end
end
