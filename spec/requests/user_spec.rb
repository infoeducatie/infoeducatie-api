require 'rails_helper'

RSpec.describe "V1::Users", type: :request do
  def register_user(attributes)
    post "/v1/users", params: {user: attributes}, as: :json
  end

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
        register_user(
          email: valid_email,
          password: valid_password,
          password_confirmation: valid_password,
          first_name: valid_first_name,
          last_name: valid_last_name
        )

        expect(response).to have_http_status(200)

        @user = User.find_by email: valid_email

        body = JSON.parse(response.body)
        expect(body["user_id"]).to eq(@user.id)
      end
    end

    context "when resource has invalid email" do
      it "responds with 422" do
        register_user(
          email: invalid_email,
          password: valid_password,
          password_confirmation: valid_password
        )

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["email"][0]).to eq("is invalid")
      end
    end

    context "when resource has empty email" do
      it "responds with 422" do
        register_user(
          email: empty_email,
          password: valid_password,
          password_confirmation: valid_password
        )

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["email"][0]).to eq("can't be blank")
      end
    end

    context "when resource has invalid password" do
      it "responds with 422" do
        register_user(
          email: valid_email,
          password: valid_password,
          password_confirmation: invalid_password
        )

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["password_confirmation"][0]).to eq("doesn't match Password")
      end
    end

    context "when resource has empty password" do
      it "responds with 422" do
        register_user(
          email: valid_email,
          password: empty_password,
          password_confirmation: valid_password
        )

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["password"][0]).to eq("can't be blank")
      end
    end

    context "when resource has empty confirmation password" do
      it "responds with 422" do
        register_user(
          email: valid_email,
          password: valid_password,
          password_confirmation: empty_password
        )

        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
        expect(body["password_confirmation"][0]).to eq("doesn't match Password")
      end
    end
  end
end
