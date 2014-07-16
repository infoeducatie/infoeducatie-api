require  'rails_helper'

RSpec.describe News do
  it "is valid" do
    news = create(:news)
    expect(news.valid?)
  end
end
