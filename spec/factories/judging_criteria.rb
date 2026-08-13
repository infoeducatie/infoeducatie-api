FactoryBot.define do
  sequence :judging_criterion_title do |number|
    "Criterion #{number}"
  end

  factory :judging_criterion do
    title { generate(:judging_criterion_title) }
    title_en { "English #{title}" }
    document do
      Rack::Test::UploadedFile.new(
        Rails.root.join(
          "db",
          "seed_assets",
          "judging_criteria",
          "documents",
          "web.pdf"
        ),
        "application/pdf"
      )
    end
    position { 10 }
    active { true }
  end
end
