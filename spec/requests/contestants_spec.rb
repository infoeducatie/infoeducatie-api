require 'rails_helper'

RSpec.describe "Contestants", type: :request do
  let!(:valid_user) {
    FactoryGirl.create(:confirmed_user)
  }

  let(:valid_headers) {
    { 'Authorization' => valid_user.access_token }
  }

  describe "GET /v1/contestants.json" do
    it "Render all the contestants" do
      contestant = FactoryGirl.create(:contestant)

      get "/v1/contestants.json", {}, valid_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)
      expect(body.size).to eq(1)
    end
  end
end
