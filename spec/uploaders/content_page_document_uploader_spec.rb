require "rails_helper"

RSpec.describe ContentPageDocumentUploader, type: :model do
  subject(:uploader) { described_class.new }

  it "accepts PDF documents only" do
    expect(uploader.extension_allowlist).to eq(%w[pdf])
    expect("application/pdf").to match(uploader.content_type_allowlist)
    expect("text/html").not_to match(uploader.content_type_allowlist)
  end

  it "limits documents to 10 MB" do
    expect(uploader.size_range).to eq(1.byte..10.megabytes)
  end
end
