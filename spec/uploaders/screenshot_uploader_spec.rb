require 'rails_helper'

RSpec.describe ScreenshotUploader do
  subject(:uploader) { described_class.new }

  it "accepts only supported image extensions and content types" do
    expect(uploader.extension_whitelist).to match_array(%w(jpeg jpg png webp))
    expect("image/png").to match(uploader.content_type_whitelist)
    expect("application/x-msdownload").not_to match(uploader.content_type_whitelist)
  end

  it "limits uploaded screenshots to 10 MB" do
    expect(uploader.size_range).to eq(1.byte..10.megabytes)
  end
end
