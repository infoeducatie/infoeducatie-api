require 'rails_helper'

RSpec.describe "rails_admin/main/_screenshot_editor_item.html.erb", type: :view do
  def render_editor_item(screenshot)
    view.form_for(screenshot, url: "/screenshots") do |form|
      view.render(
        partial: "rails_admin/main/screenshot_editor_item",
        locals: { form: form }
      )
    end
  end

  it "shows the saved image and explicit management actions" do
    screenshot = Screenshot.new
    screenshot[:screenshot] = "project-screen.png"
    allow(screenshot).to receive(:url).and_return(
      "https://data.infoeducatie.ro/project-screen.png"
    )

    html = render_editor_item(screenshot)

    expect(html).to include('data-screenshot-card')
    expect(html).to include('src="https://data.infoeducatie.ro/project-screen.png"')
    expect(html).to include("ie-screenshot-card__placeholder is-hidden")
    expect(html).to include("Open original")
    expect(html).to include("Replace")
    expect(html).to include('data-screenshot-remove')
    expect(html).to include('data-screenshot-undo')
  end

  it "renders a focused image input for a new screenshot" do
    html = render_editor_item(Screenshot.new)

    expect(html).to include("Choose an image")
    expect(html).to include('accept="image/jpeg,image/png,image/webp"')
    expect(html).to include('data-screenshot-file')
    expect(html).not_to include("Add a new Project")
  end
end
