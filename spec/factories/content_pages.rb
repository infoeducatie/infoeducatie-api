FactoryBot.define do
  factory :content_page do
    sequence(:slug) { |number| "content-page-#{number}" }
    title { "Pagină informativă" }
    title_en { "Information page" }
    body { "<p>Conținut informativ în limba română.</p>" }
    body_en { "<p>Information content in English.</p>" }
    active { true }
  end
end
