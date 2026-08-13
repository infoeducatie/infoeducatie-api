require "rails_helper"

RSpec.describe "Blog posts API", type: :request do
  it "lists published posts newest first without their full bodies" do
    older = create(:blog_post, slug: "older", published_at: 2.days.ago)
    newer = create(:blog_post, slug: "newer", published_at: 1.day.ago)

    get "/v1/blog_posts.json", params: {locale: "ro"}

    expect(response).to have_http_status(:ok)
    payload = JSON.parse(response.body)
    expect(payload.pluck("slug")).to eq([newer.slug, older.slug])
    expect(payload.first).to include("excerpt" => newer.excerpt)
    expect(payload.first).not_to have_key("body")
  end

  it "returns a localized post by slug" do
    post = create(:blog_post, slug: "community-story")

    get "/v1/blog_posts/community-story.json", params: {locale: "en"}

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include(
      "title" => post.title_en,
      "body" => post.body_en,
      "author_name" => post.author_name
    )
  end

  it "does not expose inactive or scheduled posts" do
    inactive = create(:blog_post, slug: "inactive", active: false)
    scheduled = create(:blog_post, slug: "scheduled", published_at: 1.day.from_now)

    get "/v1/blog_posts/#{inactive.slug}.json"
    expect(response).to have_http_status(:not_found)

    get "/v1/blog_posts/#{scheduled.slug}.json"
    expect(response).to have_http_status(:not_found)
  end
end
