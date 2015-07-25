require 'rails_helper'

RSpec.describe "Teachers", type: :request do
  let!(:valid_user) {
    FactoryGirl.create(:confirmed_user)
  }

  let!(:valid_edition) {
    FactoryGirl.create(:edition)
  }

  let(:valid_headers) {
    { 'Authorization' => valid_user.access_token }
  }

  describe "GET /v1/teachers.json" do
    context "list all teachers" do
      it "Render all the teachers" do
        teacher = FactoryGirl.create(:teacher)

        get "/v1/teachers", {}, valid_headers
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)
        expect(body.size).to eq(1)
      end
    end
  end

  describe "POST /v1/teachers.json" do
    context "resource is valid" do
      it "creates a teacher" do
        teacher_attributes = FactoryGirl.attributes_for(:teacher)

        post "/v1/teachers", { :teacher => teacher_attributes }, valid_headers

        expect(response).to have_http_status(201)
        body = JSON.parse(response.body)

        teacher = Teacher.last
        expect(teacher.user).to eq(valid_user)
        expect(teacher.edition).to eq(valid_edition)
      end
    end

    context "resource is invalid" do
      it "responds with 422 when address is missing" do
        teacher_attributes = FactoryGirl.attributes_for(:teacher)
        teacher_attributes[:school_name] = ""

        post "/v1/teachers", { :teacher => teacher_attributes }, valid_headers

        expect(response).to have_http_status(422)
      end
    end
  end

end
