require 'faker'

FactoryGirl.define do
  factory :sponsor do
    name Faker::Lorem.word
    # TODO: Change in a default image
    logo Faker::Lorem.word
  end
end
