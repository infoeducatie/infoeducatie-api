require 'rails_helper'

RSpec.describe "Contestants", type: :request do
  let!(:valid_user) {
    FactoryBot.create(:confirmed_user)
  }

  let!(:valid_edition) {
    FactoryBot.create(:edition)
  }

  let(:valid_headers) {
    { 'Authorization' => valid_user.access_token }
  }

  describe "GET /v1/contestants.json" do
    context "list all contestants" do
      it "Render all the contestants" do
        contestant = FactoryBot.create(:contestant)

        get "/v1/contestants", headers: valid_headers
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body.size).to eq(1)
      end
    end
  end

  describe "POST /v1/contestants.json" do
    context "resource is valid" do
      it "creates a contestant" do
        contestant_attributes = FactoryBot.attributes_for(:contestant)

        post "/v1/contestants",
          params: {contestant: contestant_attributes},
          headers: valid_headers

        expect(response).to have_http_status(201)
        body = JSON.parse(response.body)

        contestant = Contestant.last
        expect(contestant.user).to eq(valid_user)
        expect(contestant.edition).to eq(valid_edition)
      end
    end

    context "resource is invalid" do
      it "responds with 422 when address is missing" do
        contestant_attributes = FactoryBot.attributes_for(:contestant)
        contestant_attributes[:sex] = "male"
        contestant_attributes[:address] = ""

        post "/v1/contestants",
          params: {contestant: contestant_attributes},
          headers: valid_headers

        expect(response).to have_http_status(422)
      end
    end

    context "when registration is closed" do
      it "rejects the contestant" do
        valid_edition.update!(
          registration_start_date: 2.days.ago,
          registration_end_date: 1.day.ago
        )

        expect {
          post "/v1/contestants",
            params: {contestant: FactoryBot.attributes_for(:contestant)},
            headers: valid_headers
        }.not_to change(Contestant, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /v1/contestants/update_registration_step_number" do
    it "returns valid JSON for the legacy frontend" do
      post "/v1/contestants/update_registration_step_number",
        params: {step_number: 4},
        headers: valid_headers

      expect(response).to have_http_status(:accepted)
      expect(response.media_type).to eq("application/json")
      expect(JSON.parse(response.body)).to eq({})
      expect(valid_user.reload.registration_step_number).to eq(4)
    end
  end

end
