require "rails_helper"

RSpec.describe JuryCategory, type: :model do
  subject(:category) do
    described_class.new(
      title: "Comisia web",
      title_en: "Web jury",
      position: 10
    )
  end

  it "requires Romanian and English titles" do
    category.title_en = nil

    expect(category).not_to be_valid
    expect(category.errors[:title_en]).to be_present
  end

  it "localizes its title" do
    expect(category.localized_title(:ro)).to eq("Comisia web")
    expect(category.localized_title(:en)).to eq("Web jury")
  end
end
