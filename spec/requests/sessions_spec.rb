require 'rails_helper'

RSpec.describe "V1::Sessions", type: :request do
  describe "POST /v1/sign_in" do
    it "should return token when email and password are valid" do
      @user = FactoryGirl.create(:confirmed_user)

      post "/v1/sign_in", "user[email]" => "test@user.ro", "user[password]" => "TestP4ssW0rd"
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)
      expect(body["access_token"]).to eq(@user.access_token)
    end

    it "should render an authentication error when email is invalid" do
      @user = FactoryGirl.create(:confirmed_user)

      post "/v1/sign_in", "user[email]" => "trex", "user[password]" => "TestP4ssW0rd"
      expect(response).to have_http_status(422)

      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Invalid login attempt")
    end

    it "should render an authetication error when password is invalid" do
      @user = FactoryGirl.create(:confirmed_user)

      post "/v1/sign_in", "user[email]" => "test@user.ro", "user[password]" => "trex"
      expect(response).to have_http_status(422)

      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Invalid login attempt")
    end
  end
end
