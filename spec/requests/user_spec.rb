require 'rails_helper'

RSpec.describe "V1::Users", type: :request do
  describe "POST /v1/users" do

    let(:valid_email) { "test@user.ro" }
    let(:valid_password) { "TestP4ssW0rd" }
    let(:valid_first_name) { "Ionut" }
    let(:valid_last_name) { "Zapada" }
    let(:invalid_email) { "testuser.ro" }
    let(:invalid_password) { "TestPassword" }
    let(:empty_email) { "" }
    let(:empty_password) { "" }
    let(:empty_first_name) { "" }
    let(:empty_last_name) { "" }

    context "when resource is valid" do
      it "responds with 200" do
        post "/v1/users", "user[email]" => valid_email, "user[password]" => valid_password, "user[password_confirmation]" => valid_password, "user[first_name]" => valid_first_name, "user[last_name]" => valid_last_name, format: 'json'

        expect(response).to have_http_status(200)

        @user = User.find_by email: valid_email

        body = JSON.parse(response.body)
        expect(body["user_id"]).to eq(@user.id)
      end
    end

    context "when resource has invalid email" do
      it "responds with 422" do
        post "/v1/users", "user[email]" => invalid_email , "user[password]" => valid_password, "user[password_confirmation]" => valid_password, format: 'json'

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["email"][0]).to eq("is invalid")
      end
    end

    context "when resource has empty email" do
      it "responds with 422" do
        post "/v1/users", "user[email]" => empty_email, "user[password]" => valid_password, "user[password_confirmation]" => valid_password, format: 'json'

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["email"][0]).to eq("can't be blank")
      end
    end

    context "when resource has invalid password" do
      it "responds with 422" do
        post "/v1/users", "user[email]" => valid_email, "user[password]" => valid_password, "user[password_confirmation]" => invalid_password, format: 'json'

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["password_confirmation"][0]).to eq("doesn't match Password")
      end
    end

    context "when resource has empty password" do
      it "responds with 422" do
        post "/v1/users", "user[email]" => valid_email, "user[password]" => empty_password, "user[password_confirmation]" => valid_password, format: 'json'

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["password"][0]).to eq("can't be blank")
      end
    end

    context "when resource has empty confirmation password" do
      it "responds with 422" do
        post "/v1/users", "user[email]" => valid_email, "user[password]" => valid_password, "user[password_confirmation]" => empty_password , format: 'json'

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["password_confirmation"][0]).to eq("doesn't match Password")
      end
    end
  end
end
