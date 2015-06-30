FactoryGirl.define do
  sequence :name do |n|
    "Role #{n}"
  end

  factory :role do
    name { generate(:name) }
  end
end
