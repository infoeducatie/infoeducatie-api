require  'rails_helper'

RSpec.describe Sponsor do
  it "is valid" do
    talk = build(:talk)
    expect(talk.valid?)
  end
end
