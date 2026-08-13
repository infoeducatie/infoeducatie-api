require "rails_helper"

RSpec.describe PhotoAlbumCoverUploader, type: :model do
  subject(:uploader) { described_class.new }

  it "accepts supported web image formats only" do
    expect(uploader.extension_allowlist).to eq(%w[jpeg jpg png webp])
    expect("image/jpeg").to match(uploader.content_type_allowlist)
    expect("image/svg+xml").not_to match(uploader.content_type_allowlist)
  end

  it "limits cover images to 5 MB" do
    expect(uploader.size_range).to eq(1.byte..5.megabytes)
  end
end
