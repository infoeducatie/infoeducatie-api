require  'rails_helper'

RSpec.describe Edition do
  it "is valid" do
    edition = build(:edition)
    expect(edition.valid?)
  end
end
