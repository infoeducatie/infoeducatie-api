require 'rails_helper'

RSpec.describe "V1::Sessions", type: :request do
  def sign_in_with(email:, password:)
    post "/v1/sign_in", params: {user: {email: email, password: password}}, as: :json
  end

  describe "POST /v1/sign_in" do

    before { @user = FactoryBot.create(:confirmed_user) }

    context "when resource is valid" do
      it "responds with 200" do
        sign_in_with(email: @user.email, password: @user.password)
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body["access_token"]).to eq(@user.access_token)
      end
    end

    context "when resource has invalid email" do
      it "responds with 422" do
        sign_in_with(email: "trex", password: @user.password)
        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["error"]).to eq("Invalid login attempt")
      end
    end

    context "when resource has invalid password" do
      it "responds with 422" do
        sign_in_with(email: @user.email, password: "trex")
        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["error"]).to eq("Invalid login attempt")
      end
    end

    context "when the account is unconfirmed" do
      it "rejects the sign in" do
        user = FactoryBot.create(:user)

        sign_in_with(email: user.email, password: user.password)

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq("Invalid login attempt")
      end
    end
  end
end
