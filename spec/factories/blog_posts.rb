FactoryBot.define do
  factory :blog_post do
    sequence(:slug) { |number| "blog-post-#{number}" }
    title { "Articol pentru comunitate" }
    title_en { "Community article" }
    excerpt { "Un rezumat scurt al articolului." }
    excerpt_en { "A short article summary." }
    body { "<p>Conținutul articolului pentru comunitatea InfoEducație.</p>" }
    body_en { "<p>Article content for the InfoEducație community.</p>" }
    author_name { "Demo Author" }
    category { "Noutăți" }
    category_en { "News" }
    published_at { 1.day.ago }
    active { true }
  end
end
