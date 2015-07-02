require 'rails_helper'

RSpec.describe "Contestants", type: :request do
  let!(:valid_user) {
    FactoryGirl.create(:confirmed_user)
  }

  let!(:valid_edition) {
    FactoryGirl.create(:edition)
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
    context "resource is valid" do
      it "creates a contestant" do
        contestant_attributes = FactoryGirl.attributes_for(:contestant)

        post "/v1/contestants", { :contestant => contestant_attributes }, valid_headers

        expect(response).to have_http_status(201)
        body = JSON.parse(response.body)

        contestant = Contestant.last
        expect(contestant.user).to eq(valid_user)
        expect(contestant.edition).to eq(valid_edition)
      end
    end

    context "resource is invalid" do
      it "responds with 422 when address is missing" do
        contestant_attributes = FactoryGirl.attributes_for(:contestant)
        contestant_attributes[:sex] = "male"
        contestant_attributes[:address] = ""

        post "/v1/contestants", { :contestant => contestant_attributes }, valid_headers

        expect(response).to have_http_status(422)
      end
    end
  end

end
