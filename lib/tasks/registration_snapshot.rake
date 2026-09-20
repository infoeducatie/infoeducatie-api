namespace :registration do
  desc "Export a portable all-edition registration snapshot for the v2 importer"
  task export_snapshot: :environment do
    ScreenshotUploader.fog_credentials = ScreenshotUploader.fog_credentials.merge(path_style: true)
    $stdout.sync = true

    output = ENV.fetch("OUTPUT")
    snapshot_id = ENV.fetch("SNAPSHOT_ID")
    include_personal_data = ENV.fetch("INCLUDE_PERSONAL_DATA", "true") != "false"
    total = Screenshot.joins(project: :edition).count
    counts = {processed: 0, downloaded: 0, reused: 0, skipped: 0}
    summary = -> {
      "#{counts[:processed]}/#{total} processed, " \
        "#{counts[:downloaded]} downloaded, #{counts[:reused]} reused, #{counts[:skipped]} skipped"
    }
    puts "Screenshots: #{total} total"

    on_screenshot = lambda do |status, id, reason|
      counts[:processed] += 1
      counts[status] += 1
      puts "Skipped screenshot #{id}: #{reason}" if status == :skipped
      puts "Progress: #{summary.call}" if (counts[:processed] % 100).zero?
    end

    begin
      path = Integrations::RegistrationSnapshotExporter.new(
        output_directory: output,
        snapshot_id: snapshot_id,
        include_personal_data: include_personal_data,
        on_screenshot: on_screenshot
      ).export!
      puts path
    ensure
      puts "Final: #{summary.call}"
    end
  end
end
