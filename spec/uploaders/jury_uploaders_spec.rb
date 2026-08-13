require "rails_helper"

RSpec.describe "Jury uploaders", type: :model do
  it "accepts safe public image formats for category icons" do
    uploader = JuryIconUploader.new

    expect(uploader.extension_allowlist).to match_array(%w[jpeg jpg png webp])
    expect("image/png").to match(uploader.content_type_allowlist)
    expect("image/svg+xml").not_to match(uploader.content_type_allowlist)
    expect(uploader.size_range).to eq(1.byte..2.megabytes)
  end

  it "accepts safe public image formats for member photos" do
    uploader = JuryPhotoUploader.new

    expect(uploader.extension_allowlist).to match_array(%w[jpeg jpg png webp])
    expect("image/jpeg").to match(uploader.content_type_allowlist)
    expect("image/svg+xml").not_to match(uploader.content_type_allowlist)
    expect(uploader.size_range).to eq(1.byte..5.megabytes)
  end
end
