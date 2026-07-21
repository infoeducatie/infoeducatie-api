require "rails_helper"

RSpec.describe "RailsAdmin actions", type: :request do
  let(:admin) { create(:admin_user) }

  before do
    sign_in admin
  end

  it "renders the project index on Rails 8" do
    project = create(
      :project,
      finished: true,
      status: Project::STATUS_APPROVED
    )

    get "/internal/admin/project"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(project.title)
  end

  describe "project approval" do
    let!(:project) { create(:project, finished: true) }

    it "does not mutate the project on GET" do
      get "/internal/admin/project/#{project.id}/approve_project"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Approve project?")
      expect(project.reload.status).to eq(Project::STATUS_WAITING)
    end

    it "publishes and approves the project on POST" do
      discourse = instance_double(
        Discourse,
        category: {"name" => "Projects"},
        publish: 73
      )
      allow(Discourse).to receive(:new).and_return(discourse)

      post "/internal/admin/project/#{project.id}/approve_project"

      expect(response).to have_http_status(:redirect)
      expect(project.reload).to have_attributes(
        status: Project::STATUS_APPROVED,
        topic_id: 73
      )
    end
  end

  describe "project rejection" do
    let!(:project) do
      create(
        :project,
        finished: true,
        status: Project::STATUS_APPROVED,
        topic_id: 73
      )
    end

    it "requires POST before changing status" do
      discourse = instance_double(Discourse, delete: true)
      allow(Discourse).to receive(:new).and_return(discourse)

      get "/internal/admin/project/#{project.id}/reject_project"
      expect(project.reload.status).to eq(Project::STATUS_APPROVED)

      post "/internal/admin/project/#{project.id}/reject_project"
      expect(response).to have_http_status(:redirect)
      expect(project.reload.status).to eq(Project::STATUS_REJECTED)
      expect(discourse).to have_received(:delete).with(73)
    end
  end
end
