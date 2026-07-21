require 'rails_helper'

RSpec.describe Screenshot, type: :model do
  describe "previewable?" do
    it "recognizes browser-safe image extensions case-insensitively" do
      screenshot = described_class.new
      screenshot[:screenshot] = "Project_SCREENSHOT.JPG"

      expect(screenshot.previewable?).to eq(true)
    end

    it "does not render historical non-image attachments as images" do
      screenshot = described_class.new
      screenshot[:screenshot] = "project-documentation.pdf"

      expect(screenshot.previewable?).to eq(false)
    end
  end

  describe "accepted project synchronization" do
    it "updates the forum content after a screenshot changes" do
      project = instance_double(Project, status: Project::STATUS_APPROVED)
      screenshot = described_class.new
      allow(screenshot).to receive(:project).and_return(project)

      expect(project).to receive(:update_discourse)

      screenshot.update_project_discourse
    end

    it "does not update forum content for an unapproved project" do
      project = instance_double(Project, status: Project::STATUS_WAITING)
      screenshot = described_class.new
      allow(screenshot).to receive(:project).and_return(project)

      expect(project).not_to receive(:update_discourse)

      screenshot.update_project_discourse
    end
  end
end
