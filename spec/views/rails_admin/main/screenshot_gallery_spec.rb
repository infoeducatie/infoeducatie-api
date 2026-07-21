require 'rails_helper'

RSpec.describe "rails_admin/main/_screenshot_gallery.html.erb", type: :view do
  it "renders image screenshots as clickable previews" do
    screenshot = instance_double(
      Screenshot,
      url: "https://data.infoeducatie.ro/screenshot.png",
      filename: "screenshot.png",
      previewable?: true
    )

    render partial: "rails_admin/main/screenshot_gallery",
           locals: { screenshots: [screenshot] }

    expect(rendered).to include('href="https://data.infoeducatie.ro/screenshot.png"')
    expect(rendered).to include('<img')
  end

  it "does not link unsupported historical attachments" do
    screenshot = instance_double(
      Screenshot,
      url: "https://data.infoeducatie.ro/Update.exe",
      filename: "Update.exe",
      previewable?: false
    )

    render partial: "rails_admin/main/screenshot_gallery",
           locals: { screenshots: [screenshot] }

    expect(rendered).to include("Unsupported: Update.exe")
    expect(rendered).not_to include('href="https://data.infoeducatie.ro/Update.exe"')
  end
end
