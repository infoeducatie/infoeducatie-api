require "rails_helper"
require "base64"
require "tempfile"

RSpec.describe "Jury API", type: :request do
  after do
    Array(@temporary_uploads).each(&:close!)
  end

  it "returns active members grouped by ordered localized categories" do
    second_category = create(
      :jury_category,
      title: "Comisia tehnica",
      title_en: "Technical committee",
      position: 20
    )
    first_category = create(
      :jury_category,
      title: "Conducerea juriului",
      title_en: "Jury leadership",
      icon: uploaded_png("icon.png"),
      position: 10
    )
    create_member(
      name: "Second member",
      category: first_category,
      title: "Vicepresedinte",
      title_en: "Vice president",
      occupation_en: "Teacher @ Example College",
      position: 20
    )
    create_member(name: "First member", category: first_category, position: 10)
    create_member(name: "Hidden member", category: first_category, active: false)
    create_member(name: "Technical member", category: second_category)
    hidden_category = create(
      :jury_category,
      title: "Ascunsa",
      title_en: "Hidden",
      position: 5,
      active: false
    )
    create_member(name: "Invisible", category: hidden_category)

    get "/v1/jury.json", params: {locale: "en"}

    expect(response).to have_http_status(:ok)
    payload = JSON.parse(response.body)
    expect(payload.map { |category| category["title"] })
      .to eq(["Jury leadership", "Technical committee"])
    expect(payload.first["icon_url"]).to match(%r{/uploads/jury_categories/})
    expect(payload.first["members"].map { |member| member["name"] })
      .to eq(["First member", "Second member"])
    expect(payload.first.dig("members", 1, "title")).to eq("Vice president")
    expect(payload.first.dig("members", 1, "occupation"))
      .to eq("Teacher @ Example College")
    expect(payload.first.dig("members", 0, "photo_url"))
      .to match(%r{/uploads/jury_members/})
  end

  it "uses Romanian member content as the English fallback" do
    category = create(
      :jury_category,
      title: "Comisia web",
      title_en: "Web jury"
    )
    create_member(
      name: "Example member",
      category: category,
      title: "Presedinte",
      occupation: "Profesor @ Colegiul Exemplu"
    )

    get "/v1/jury.json", params: {locale: "en"}

    member = JSON.parse(response.body).first.fetch("members").first
    expect(member["title"]).to eq("Presedinte")
    expect(member["occupation"]).to eq("Profesor @ Colegiul Exemplu")
  end

  def create_member(
    name:,
    category:,
    title: nil,
    title_en: nil,
    occupation: "Profesor @ Colegiul Exemplu",
    occupation_en: nil,
    position: 10,
    active: true
  )
    JuryMember.create!(
      jury_category: category,
      title: title,
      title_en: title_en,
      name: name,
      photo: uploaded_png("#{name.parameterize}.png"),
      occupation: occupation,
      occupation_en: occupation_en,
      position: position,
      active: active
    )
  end

  def uploaded_png(filename)
    file = Tempfile.new(["jury-image", ".png"])
    (@temporary_uploads ||= []) << file
    file.binmode
    file.write(
      Base64.decode64(
        "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII="
      )
    )
    file.rewind
    Rack::Test::UploadedFile.new(
      file.path,
      "image/png",
      original_filename: filename
    )
  end
end
