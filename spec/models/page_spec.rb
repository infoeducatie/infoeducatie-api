require  'rails_helper'

RSpec.describe Page do
  it "is valid" do
    page = build(:page)
    expect(page.valid?)
  end
end
