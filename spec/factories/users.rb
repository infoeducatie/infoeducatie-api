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

  factory :valid_user_with_contestant, class: User do
    email "test3@user.ro"
    password "TestP4ssW0rd"
    first_name "Ionut"
    last_name "Zapada"

    after(:create) { |user|
      user.confirm!

      contestant = create(:contestant)
      user.contestants << contestant
    }
  end
end
