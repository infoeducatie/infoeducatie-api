require 'rails_helper'

RSpec.describe "Contestants", type: :request do
  let!(:valid_user) {
    FactoryGirl.create(:confirmed_user)
  }

  let(:valid_headers) {
    { 'Authorization' => valid_user.access_token }
  }

  describe "GET /v1/contestants.json" do
    context "list all contestants" do
      it "Render all the contestants" do
        contestant = FactoryGirl.create(:contestant)

        get "/v1/contestants", {}, valid_headers
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body.size).to eq(1)
      end
    end
  end

  describe "POST /v1/contestants.json" do
    context "a valid entity" do
      it "creates a contestant" do
        contestant_attributes = FactoryGirl.attributes_for(:contestant)
        contestant_attributes[:sex] = "male"

        post "/v1/contestants", { :contestant => contestant_attributes }, valid_headers

        expect(response).to have_http_status(201)
        body = JSON.parse(response.body)
      end
    end
  end
end
