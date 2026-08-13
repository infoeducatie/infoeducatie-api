require "rails_helper"

RSpec.describe BlogPost, type: :model do
  subject(:post) { build(:blog_post) }

  it "uses Romanian content as the English fallback" do
    post.title_en = nil
    post.excerpt_en = nil
    post.body_en = nil
    post.category_en = nil

    expect(post).to be_valid
    expect(post.localized_title(:en)).to eq(post.title)
    expect(post.localized_excerpt(:en)).to eq(post.excerpt)
    expect(post.localized_body(:en)).to eq(post.body)
  end

  it "requires complete English article content when translation starts" do
    post.body_en = nil

    expect(post).not_to be_valid
    expect(post.errors[:body_en]).to be_present
  end

  it "publishes only active posts whose date has arrived" do
    published = create(:blog_post)
    create(:blog_post, active: false)
    create(:blog_post, published_at: 1.day.from_now)

    expect(described_class.published).to contain_exactly(published)
  end
end
