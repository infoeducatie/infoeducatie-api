FactoryBot.define do
  sequence :jury_category_title do |number|
    "Jury category #{number}"
  end

  factory :jury_category do
    title { generate(:jury_category_title) }
    title_en { "English #{title}" }
    position { 10 }
    active { true }
  end

  factory :jury_member do
    association :jury_category
    sequence(:name) { |number| "Jury member #{number}" }
    photo do
      Rack::Test::UploadedFile.new(
        Rails.root.join("db", "seed_assets", "jury", "photos", "default.png"),
        "image/png"
      )
    end
    occupation { "Profesor @ Example School" }
    position { 10 }
    active { true }
  end
end
