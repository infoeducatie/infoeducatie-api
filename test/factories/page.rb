require 'faker'

FactoryGirl.define do
  factory :page do
    edition
    name Faker::Lorem.sentence
    body Faker::Lorem.paragraph
  end
end
