namespace :registration do
  desc "Export a portable all-edition registration snapshot for the v2 importer"
  task export_snapshot: :environment do
    output = ENV.fetch("OUTPUT")
    snapshot_id = ENV.fetch("SNAPSHOT_ID")
    include_personal_data = ENV.fetch("INCLUDE_PERSONAL_DATA", "true") != "false"
    path = Integrations::RegistrationSnapshotExporter.new(
      output_directory: output,
      snapshot_id: snapshot_id,
      include_personal_data: include_personal_data
    ).export!
    puts path
  end
end
