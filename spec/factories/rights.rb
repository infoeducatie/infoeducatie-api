FactoryBot.define do
  factory :right do
    association :user
    association :role
  end
end
