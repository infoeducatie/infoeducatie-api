require 'faker'

FactoryGirl.define do
  factory :talk do
    title Faker::Lorem.sentence
    description Faker::Lorem.paragraph
    scheduled_at Faker::Number.digit.to_i.days.from_now
    duration Faker::Number
    location Faker::Lorem.sentence
  end
end
