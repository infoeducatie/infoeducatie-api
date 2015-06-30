FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :user do
    email { generate(:email) }
    password "TestP4ssW0rd"

    first_name "Anutsa"
    last_name "Stark"
  end

  factory :confirmed_user, class: User do
    email { generate(:email) }
    password "TestP4ssW0rd"
    after(:create) { |user| user.confirm! }

    first_name "Ionut"
    last_name "Zapada"
  end
end
