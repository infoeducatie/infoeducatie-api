require "rails_helper"

RSpec.describe "Judging criteria API", type: :request do
  it "returns active criteria in localized display order" do
    create(
      :judging_criterion,
      title: "Web",
      title_en: "Web",
      position: 20
    )
    create(
      :judging_criterion,
      title: "Educational",
      title_en: "Educational software",
      position: 10
    )
    create(
      :judging_criterion,
      title: "Hidden",
      title_en: "Hidden",
      position: 5,
      active: false
    )

    get "/v1/judging_criteria.json", params: {locale: "en"}

    expect(response).to have_http_status(:ok)
    payload = JSON.parse(response.body)
    expect(payload.map { |criterion| criterion["title"] })
      .to eq(["Educational software", "Web"])
    expect(payload.first["document_url"])
      .to match(%r{/uploads/judging_criteria/})
  end
end
