require 'faker'

FactoryGirl.define do
  factory :news do
    title Faker::Lorem.sentence
    description Faker::Lorem.paragraph
  end
end
