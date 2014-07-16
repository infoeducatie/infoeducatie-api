require 'faker'

FactoryGirl.define do
  factory :sponsor do
    name Faker::Lorem.sentence
    # TODO: Change in a default image
    logo Faker::Lorem.paragraph
  end
end
