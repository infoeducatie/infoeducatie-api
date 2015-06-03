FactoryGirl.define do
  factory :user do
    email "test@user.ro"
    password "TestP4ssW0rd"
  end

  factory :confirmed_user, :parent => :user do
    after(:create) { |user| user.confirm! }
  end
end
