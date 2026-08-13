require "rails_helper"

RSpec.describe JudgingCriterion, type: :model do
  subject(:criterion) do
    build(
      :judging_criterion,
      title: "Educational",
      title_en: "Educational software"
    )
  end

  it "requires Romanian and English titles" do
    criterion.title_en = nil

    expect(criterion).not_to be_valid
    expect(criterion.errors[:title_en]).to be_present
  end

  it "localizes its title" do
    expect(criterion.localized_title(:ro)).to eq("Educational")
    expect(criterion.localized_title(:en)).to eq("Educational software")
  end
end
