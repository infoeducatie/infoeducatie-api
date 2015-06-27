require 'rails_helper'

RSpec.describe "V1::Sessions", type: :request do
  describe "POST /v1/sign_in" do

    let(:valid_email) { "test2@user.ro" }
    let(:valid_password) { "TestP4ssW0rd" }

    before { @user = FactoryGirl.create(:confirmed_user) }

    context "when resource is valid" do
      it "responds with 200" do
        post "/v1/sign_in", "user[email]" => valid_email, "user[password]" => valid_password
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body["access_token"]).to eq(@user.access_token)
      end
    end

    context "when resource has invalid email" do
      it "reponds with 422" do
        post "/v1/sign_in", "user[email]" => "trex", "user[password]" => valid_password
        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["error"]).to eq("Invalid login attempt")
      end
    end

    context "when resource has invalid password" do
      it "reponds with 422" do
        post "/v1/sign_in", "user[email]" => valid_email, "user[password]" => "trex"
        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["error"]).to eq("Invalid login attempt")
      end
    end
  end
end
