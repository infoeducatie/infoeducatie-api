require "rails_helper"

RSpec.describe SponsorImageUploader, type: :model do
  subject(:uploader) { described_class.new }

  it "accepts safe public image formats" do
    expect(uploader.extension_allowlist).to match_array(%w[jpeg jpg png webp])
    expect("image/png").to match(uploader.content_type_allowlist)
    expect("image/svg+xml").not_to match(uploader.content_type_allowlist)
  end

  it "limits sponsor images to 5 MB" do
    expect(uploader.size_range).to eq(1.byte..5.megabytes)
  end
end
