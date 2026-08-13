FactoryBot.define do
  sequence :sponsor_tier_name do |number|
    "Sponsor tier #{number}"
  end

  factory :sponsor_tier do
    name { generate(:sponsor_tier_name) }
    position { 10 }
  end
end
