require "rails_helper"
require "base64"
require "tempfile"

RSpec.describe "Sponsors API", type: :request do
  after do
    Array(@temporary_uploads).each(&:close!)
  end

  it "returns active sponsors grouped by ordered localized tiers" do
    second_tier = create(
      :sponsor_tier,
      name: "Susținători",
      name_en: "Supporters",
      position: 20
    )
    first_tier = create(
      :sponsor_tier,
      name: "Parteneri",
      name_en: "Partners",
      position: 10
    )
    create_sponsor(title: "Second", tier: first_tier, position: 20)
    create_sponsor(title: "First", tier: first_tier, position: 10)
    create_sponsor(title: "Hidden", tier: first_tier, active: false)
    create_sponsor(title: "Supporter", tier: second_tier)

    get "/v1/sponsors.json", params: {locale: "en"}

    expect(response).to have_http_status(:ok)
    payload = JSON.parse(response.body)
    expect(payload.map { |tier| tier["title"] }).to eq(["Partners", "Supporters"])
    expect(payload.first["sponsors"].map { |sponsor| sponsor["title"] })
      .to eq(["First", "Second"])
    expect(payload.first.dig("sponsors", 0, "image_url"))
      .to match(%r{/uploads/sponsors/})
  end

  it "uses the Romanian tier name as the English fallback" do
    tier = create(:sponsor_tier, name: "Parteneri", name_en: nil)
    create_sponsor(title: "Example", tier: tier)

    get "/v1/sponsors.json", params: {locale: "en"}

    expect(JSON.parse(response.body).first["title"]).to eq("Parteneri")
  end

  def create_sponsor(title:, tier:, position: 10, active: true)
    Sponsor.create!(
      title: title,
      sponsor_tier: tier,
      image: uploaded_png,
      website_url: "https://example.test/#{title.parameterize}",
      position: position,
      active: active
    )
  end

  def uploaded_png
    file = Tempfile.new(["sponsor-logo", ".png"])
    (@temporary_uploads ||= []) << file
    file.binmode
    file.write(
      Base64.decode64(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
      )
    )
    file.rewind
    Rack::Test::UploadedFile.new(file.path, "image/png", original_filename: "logo.png")
  end
end
