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
      exported_editions = payload.fetch("editions")
      exported_edition = exported_editions.find { |item| item.fetch("id") == edition.id }
      exported_project = exported_edition.fetch("projects").find { |item| item.fetch("id") == project.id }
      exported_draft = exported_edition.fetch("projects").find { |item| item.fetch("title") == "Unfinished" }
      exported_screenshot = exported_project.fetch("screenshots").sole

      expect(payload).to include(
        "snapshotId" => "legacy-final-2026",
        "includesAllEditions" => true
      )
      expect(exported_editions.map { |item| item.fetch("id") }).to match_array(Edition.pluck(:id))
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
      exported_editions = JSON.parse(File.read(path)).fetch("editions")
      exported_edition = exported_editions.find { |item| item.fetch("id") == edition.id }
      participant = exported_edition.fetch("contestants").sole
      expect(exported_editions.map { |item| item.fetch("id") }).to match_array(Edition.pluck(:id))
      expect(participant.fetch("privateData")).to be_nil
      expect(File.read(path)).not_to include("ada@example.test")
    end
  end

  it "groups ID-named screenshots into shared folders and keeps original names in JSON" do
    project = create(:project, edition: edition, contestants: [contestant])
    create_screenshot(project, id: 320_042, filename: "First.PNG")
    create_screenshot(project, id: 320_074, filename: "Second.JPG")
    create_screenshot(project, id: 320_043, filename: "Third.PNG")

    Dir.mktmpdir do |directory|
      output = File.join(directory, "snapshot")
      path = described_class.new(output_directory: output, snapshot_id: "bucket-layout").export!
      exported_edition = JSON.parse(File.read(path)).fetch("editions").find { |item| item.fetch("id") == edition.id }
      exported_project = exported_edition.fetch("projects").find { |item| item.fetch("id") == project.id }
      exported_screenshots = exported_project.fetch("screenshots").index_by { |item| item.fetch("id") }

      expect(exported_screenshots.transform_values { |item| [item.fetch("sourcePath"), item.fetch("originalFileName")] }).to eq(
        320_042 => ["screenshots/10/320042.png", "First.PNG"],
        320_074 => ["screenshots/10/320074.jpg", "Second.JPG"],
        320_043 => ["screenshots/11/320043.png", "Third.PNG"]
      )
      expect(Dir.children(File.join(output, "screenshots")).sort).to eq(%w[10 11])
      exported_screenshots.each_value do |item|
        saved = File.join(output, item.fetch("sourcePath"))
        expect(File).to exist(saved)
        expect(item.fetch("sha256")).to eq(Digest::SHA256.file(saved).hexdigest.upcase)
      end
    end
  end

  it "retains downloaded screenshots after failure and reuses them for the same snapshot ID" do
    project = create(:project, edition: edition, contestants: [contestant])
    screenshot = create_screenshot(project, filename: "Retry.PNG")

    Dir.mktmpdir do |directory|
      output = File.join(directory, "snapshot")
      expect {
        described_class.new(
          output_directory: output,
          snapshot_id: "retry-id",
          on_screenshot: ->(status, _id, _reason) { raise "interrupted" if status == :downloaded }
        ).export!
      }.to raise_error("interrupted")

      saved = File.join(output, "screenshots", format("%02d", screenshot.id % 32), "#{screenshot.id}.png")
      expect(File).to exist(saved)
      expect(File.read(File.join(output, ".registration-snapshot-id"))).to eq("retry-id")

      allow_any_instance_of(ScreenshotUploader).to receive(:file).and_raise("uploader should not be read")
      statuses = []
      path = described_class.new(
        output_directory: output,
        snapshot_id: "retry-id",
        on_screenshot: ->(status, _id, _reason) { statuses << status }
      ).export!
      expect(statuses).to eq([:reused])
      expect(File).to exist(path)
      expect {
        described_class.new(output_directory: output, snapshot_id: "other-id").export!
      }.to raise_error(ArgumentError, /different snapshot ID/)
      expect(File).to exist(saved)
    end
  end

  it "skips blank screenshots without an output file or a display-order gap" do
    project = create(:project, edition: edition, contestants: [contestant])
    first = create_screenshot(project, filename: "First.PNG")
    blank = create_screenshot(project, filename: "Blank.PNG")
    last = create_screenshot(project, filename: "Last.PNG")

    Dir.mktmpdir do |directory|
      output = File.join(directory, "snapshot")
      exporter = described_class.new(output_directory: output, snapshot_id: "blank-retry")
      exporter.export!
      blank_path = File.join(output, "screenshots", format("%02d", blank.id % 32), "#{blank.id}.png")
      File.binwrite(blank_path, "")
      File.binwrite(blank.screenshot.file.path, "")

      events = []
      path = described_class.new(
        output_directory: output,
        snapshot_id: "blank-retry",
        on_screenshot: ->(status, id, reason) { events << [status, id, reason] }
      ).export!
      exported_edition = JSON.parse(File.read(path)).fetch("editions").find { |item| item.fetch("id") == edition.id }
      exported_project = exported_edition.fetch("projects").find { |item| item.fetch("id") == project.id }
      exported_screenshots = exported_project.fetch("screenshots")

      expect(exported_screenshots.map { |item| item.fetch("id") }).to eq([first.id, last.id])
      expect(exported_screenshots.map { |item| item.fetch("displayOrder") }).to eq([1, 2])
      expect(File).not_to exist(blank_path)
      expect(events).to eq([
        [:reused, first.id, nil],
        [:skipped, blank.id, "blank source"],
        [:reused, last.id, nil]
      ])
    end
  end

  def create_screenshot(project, filename: "registration.png", id: nil)
    bytes = Base64.decode64(
      "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
    )
    Dir.mktmpdir do |directory|
      source = File.join(directory, filename)
      File.binwrite(source, bytes)
      Screenshot.create!(
        id: id,
        project: project,
        screenshot: Rack::Test::UploadedFile.new(source, "image/png", true)
      )
    end
  end
end
