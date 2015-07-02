FactoryGirl.define do
  factory :colaborator do
    association :contestant
    association :project
  end
end
