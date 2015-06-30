require 'rails_helper'

RSpec.describe "V1::Projects", type: :request do
  describe "POST /v1/projects" do

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

        post "/v1/projects?contestant_id=#{contestant.id}", { :project => project_attributes }, valid_headers
        expect(response).to have_http_status(201)

        body = JSON.parse(response.body)

        project = Project.last
        expect(contestant.projects).to eq([project])
      end
    end
  end
end
