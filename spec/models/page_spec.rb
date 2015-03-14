require  'rails_helper'

RSpec.describe Page do
  it "is valid" do
    page = create(:page)
    expect(page.valid?)
  end
end
