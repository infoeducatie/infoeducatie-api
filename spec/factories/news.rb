require 'faker'

FactoryGirl.define do
  factory :news do
    edition
    title Faker::Lorem.sentence
    description Faker::Lorem.paragraph
  end
end
