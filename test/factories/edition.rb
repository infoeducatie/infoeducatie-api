require 'faker'

FactoryGirl.define do
  factory :edition do
    start Faker::Number.digit.to_i.days.ago
    self.end Faker::Number.digit.to_i.days.from_now
    cardinal 1
    motto Faker::Lorem.sentence(3)
    created_at Time.now
    updated_at Time.now
  end
end
