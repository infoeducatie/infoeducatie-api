require "rails_helper"

RSpec.describe ContentPage, type: :model do
  subject(:page) { build(:content_page) }

  it "accepts URL-safe slugs" do
    page.slug = "about-the-competition"

    expect(page).to be_valid
  end

  it "rejects slugs with spaces or uppercase letters" do
    page.slug = "About page"

    expect(page).not_to be_valid
    expect(page.errors[:slug]).to be_present
  end

  it "uses Romanian content as the English fallback" do
    page.title_en = nil
    page.body_en = nil

    expect(page.localized_title(:en)).to eq(page.title)
    expect(page.localized_body(:en)).to eq(page.body)
  end

  it "uses the Romanian document as the English fallback" do
    allow(page.document).to receive(:url).and_return("/uploads/program-ro.pdf")
    allow(page).to receive(:document?).and_return(true)
    allow(page).to receive(:document_en?).and_return(false)

    expect(page.localized_document_url(:en)).to eq("/uploads/program-ro.pdf")
  end

  it "requires both English fields when either one is provided" do
    page.body_en = nil

    expect(page).not_to be_valid
    expect(page.errors[:body_en]).to be_present
  end
end
