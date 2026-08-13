require "rails_helper"

RSpec.describe JuryMember, type: :model do
  subject(:member) do
    described_class.new(
      jury_category: build(:jury_category),
      name: "Maria Popescu",
      occupation: "Profesor @ Colegiul Exemplu",
      position: 10
    )
  end

  it "allows the member title to be omitted" do
    member.title = nil

    member.validate

    expect(member.errors[:title]).to be_empty
  end

  it "uses Romanian content as the English fallback" do
    member.title = "Presedinte"
    member.title_en = nil
    member.occupation_en = nil

    expect(member.localized_title(:en)).to eq("Presedinte")
    expect(member.localized_occupation(:en))
      .to eq("Profesor @ Colegiul Exemplu")
  end

  it "uses English title and occupation when provided" do
    member.title = "Presedinte"
    member.title_en = "President"
    member.occupation_en = "Teacher @ Example College"

    expect(member.localized_title(:en)).to eq("President")
    expect(member.localized_occupation(:en))
      .to eq("Teacher @ Example College")
  end
end
