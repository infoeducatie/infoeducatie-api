require "rails_helper"

RSpec.describe Sponsor, type: :model do
  subject(:sponsor) do
    described_class.new(
      title: "Example sponsor",
      sponsor_tier: build(:sponsor_tier),
      position: 10
    )
  end

  it "accepts complete HTTP and HTTPS website URLs" do
    sponsor.website_url = "https://example.test/sponsor"

    sponsor.validate

    expect(sponsor.errors[:website_url]).to be_empty
  end

  it "allows the website URL to be omitted" do
    sponsor.website_url = nil

    sponsor.validate

    expect(sponsor.errors[:website_url]).to be_empty
  end

  it "rejects non-web website URLs" do
    sponsor.website_url = "javascript:alert(1)"

    sponsor.validate

    expect(sponsor.errors[:website_url]).to include(
      "must be a complete HTTP or HTTPS URL"
    )
  end
end
