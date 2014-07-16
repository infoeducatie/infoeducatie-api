require  'rails_helper'

RSpec.describe Sponsor do
  it "is valid" do
    sponsor = build(:sponsor)
    expect(sponsor.valid?)
  end
end
