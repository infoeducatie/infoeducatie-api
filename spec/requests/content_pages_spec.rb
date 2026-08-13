require "rails_helper"

RSpec.describe "Content pages API", type: :request do
  it "returns a published page in the requested language" do
    create(
      :content_page,
      slug: "about",
      title: "Despre InfoEducație",
      title_en: "About InfoEducație",
      body: "<p>Conținut românesc.</p>",
      body_en: "<p>English content.</p>"
    )

    get "/v1/content_pages/about.json", params: {locale: "en"}

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include(
      "slug" => "about",
      "title" => "About InfoEducație",
      "body" => "<p>English content.</p>",
      "document_url" => nil
    )
  end

  it "does not expose inactive pages" do
    create(:content_page, slug: "about", active: false)

    get "/v1/content_pages/about.json"

    expect(response).to have_http_status(:not_found)
  end
end
