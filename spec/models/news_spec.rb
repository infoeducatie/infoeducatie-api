require  'rails_helper'

RSpec.describe News do
  it "is valid" do
    news = build(:news)
    expect(news.valid?)
  end
end
