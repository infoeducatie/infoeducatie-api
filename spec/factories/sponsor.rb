require 'faker'

FactoryGirl.define do
  factory :sponsor do
    name Faker::Lorem.characters(7)
    # TODO: Change in a default image
    logo Faker::Lorem.characters(7)
  end
end
