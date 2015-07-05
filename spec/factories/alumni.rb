FactoryGirl.define do
  factory :alumnus, class: Alumnus do
    description "I am old"
    association :user
    editions { build_list(:edition, 1) }
  end
end
