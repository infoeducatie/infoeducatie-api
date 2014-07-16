require  'rails_helper'

RSpec.describe Edition do
  it "is valid" do
    edition = create(:edition)
    expect(edition.valid?)
  end
end
