FactoryGirl.define do
  factory :user do
    email "test@user.ro"
    password "TestP4ssW0rd"

    first_name "Anutsa"
    last_name "Stark"
  end

  factory :confirmed_user, class: User do
    email "test2@user.ro"
    password "TestP4ssW0rd"
    after(:create) { |user| user.confirm! }

    first_name "Ionut"
    last_name "Zapada"
  end
end
