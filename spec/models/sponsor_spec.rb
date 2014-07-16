require  'rails_helper'

RSpec.describe Sponsor do
  it "is valid" do
    sponsor = create(:sponsor)
    expect(sponsor.valid?)
  end
end
