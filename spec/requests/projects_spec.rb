require 'rails_helper'

RSpec.describe "V1::Projects", type: :request do
  describe "POST /v1/projects" do

    let!(:valid_web_category) {
      Category.find_by(name: "web")
    }

    let!(:valid_user_with_contestant) { 
      FactoryGirl.create(:valid_user_with_contestant)
    }

    let(:valid_headers) {
      { 'Authorization' => valid_user_with_contestant.access_token }
    }

    context "when resource is valid" do
      it "responds with 200" do
        contestant = valid_user_with_contestant.contestants.first
        project_attributes = FactoryGirl.attributes_for(:project)
        params = {
          :project => project_attributes,
          :category_name => "web"
        }

        post "/v1/projects", params, valid_headers

        expect(response).to have_http_status(201)
        body = JSON.parse(response.body)

        project = Project.last
        expect(contestant.projects).to eq([project])
        expect(project.category).to eq(Category.find_by(name: "web"))
      end
    end

    context "when resource is invalid" do
      it "responds with 422 when category is invalid" do
        contestant = valid_user_with_contestant.contestants.first
        project_attributes = FactoryGirl.attributes_for(:project)
        params = {
          :project => project_attributes,
          :category_name => "random"
        }

        post "/v1/projects?contestant_id=#{contestant.id}", params, valid_headers
        expect(response).to have_http_status(422)

        body = JSON.parse(response.body)
      end
    end
  end
end
