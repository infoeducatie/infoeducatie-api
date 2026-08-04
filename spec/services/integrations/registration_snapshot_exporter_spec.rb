require "rails_helper"
require "base64"
require "tmpdir"

RSpec.describe Integrations::RegistrationSnapshotExporter do
  let(:edition) { create(:edition, year: 2026, name: "National 2026") }
  let(:contestant) do
    create(
      :contestant,
      edition: edition,
      user: create(:user, first_name: "Ada", last_name: "Lovelace", email: "ada@example.test")
    )
  end

  it "exports every registration branch, result, prize, relationship, and screenshot portably" do
    teacher = create(
      :teacher,
      edition: edition,
      user: create(:user, first_name: "Grace", last_name: "Hopper", email: "grace@example.test")
    )
    project = create(
      :project,
      edition: edition,
      contestants: [contestant],
      title: "Compiler",
      finished: true,
      status: Project::STATUS_APPROVED,
      score: 91.5,
      extra_score: 3.5,
      prize: "I"
    )
    screenshot = create_screenshot(project)
    create(
      :project,
      edition: edition,
      contestants: [contestant],
      title: "Unfinished",
      finished: false
    )

    Dir.mktmpdir do |directory|
      output = File.join(directory, "snapshot")
      path = described_class.new(
        output_directory: output,
        snapshot_id: "legacy-final-2026"
      ).export!
      payload = JSON.parse(File.read(path))
      exported_edition = payload.fetch("editions").sole
      exported_project = exported_edition.fetch("projects").find { |item| item.fetch("id") == project.id }
      exported_draft = exported_edition.fetch("projects").find { |item| item.fetch("title") == "Unfinished" }
      exported_screenshot = exported_project.fetch("screenshots").sole

      expect(payload).to include(
        "snapshotId" => "legacy-final-2026",
        "includesAllEditions" => true
      )
      expect(exported_edition.fetch("contestants").sole.dig("privateData", "email")).to eq(
        "ada@example.test"
      )
      expect(exported_edition.fetch("teachers").sole.fetch("id")).to eq(teacher.id)
      expect(exported_project).to include(
        "status" => "approved",
        "projectScore" => 91.5,
        "openScore" => 3.5,
        "finalPrize" => "I",
        "contestantIds" => [contestant.id]
      )
      expect(exported_draft.fetch("status")).to eq("draft")
      expect(exported_screenshot.fetch("sourcePath")).not_to start_with("/")
      copied = File.join(output, exported_screenshot.fetch("sourcePath"))
      expect(File.binread(copied)).to eq(screenshot.screenshot.file.read)
      expect(exported_screenshot.fetch("sha256")).to eq(
        Digest::SHA256.file(copied).hexdigest.upcase
      )
      expect(File.read(path)).not_to include("encrypted_password", "access_token", "confirmation_token")
    end
  end

  it "can omit contestant personal data" do
    contestant
    Dir.mktmpdir do |directory|
      path = described_class.new(
        output_directory: File.join(directory, "snapshot"),
        snapshot_id: "public-rehearsal",
        include_personal_data: false
      ).export!
      participant = JSON.parse(File.read(path)).fetch("editions").sole.fetch("contestants").sole
      expect(participant.fetch("privateData")).to be_nil
      expect(File.read(path)).not_to include("ada@example.test")
    end
  end

  def create_screenshot(project)
    bytes = Base64.decode64(
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
    )
    file = Tempfile.new(["registration", ".png"])
    file.binmode
    file.write(bytes)
    file.rewind
    Screenshot.create!(
      project: project,
      screenshot: Rack::Test::UploadedFile.new(file.path, "image/png", true)
    )
  ensure
    file&.close!
  end
end
