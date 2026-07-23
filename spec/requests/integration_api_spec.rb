require "rails_helper"

RSpec.describe "Integration API", type: :request do
  let(:admin) { create(:admin_user) }
  let!(:competition) do
    create(
      :edition,
      year: 2026,
      name: "National 2026",
      current: false,
      show_results: true
    )
  end
  let!(:participant) do
    create(
      :contestant,
      edition: competition,
      user: create(
        :confirmed_user,
        first_name: "Ana",
        last_name: "Popescu",
        email: "ana@example.com"
      ),
      cnp: "6060101123456",
      id_card_type: "CI",
      id_card_number: "VX123456",
      phone_number: "+40700111222"
    )
  end
  let!(:project) do
    create(
      :project,
      title: "Atlas",
      contestants: [participant],
      edition: competition,
      finished: true,
      status: Project::STATUS_APPROVED,
      score: 90,
      extra_score: 5,
      prize: "I"
    )
  end

  def issue_token(scopes)
    ApiCredential.issue!(
      {
        name: "Request spec",
        scopes: scopes,
        expires_at: 90.days.from_now
      },
      created_by: admin
    )
  end

  def authorization(token)
    {"Authorization" => "Bearer #{token}"}
  end

  it "requires a service API key and rejects legacy user tokens" do
    get "/v1/integrations/competitions"

    expect(response).to have_http_status(:unauthorized)
    expect(response.headers["WWW-Authenticate"]).to include("invalid_token")
    expect(response.headers["Cache-Control"]).to include("no-store")
    expect(response.parsed_body.dig("error", "request_id")).to be_present

    user = create(:confirmed_user)
    get "/v1/integrations/competitions",
      headers: authorization(user.access_token)

    expect(response).to have_http_status(:unauthorized)
  end

  it "rate limits rejected authentication attempts by source IP" do
    allow(Rails.cache).to receive(:increment).and_return(
      V1::Integrations::BaseController::RATE_LIMIT + 1
    )

    get "/v1/integrations/competitions"

    expect(response).to have_http_status(:too_many_requests)
    expect(response.headers["Retry-After"]).to eq("60")
    expect(response.parsed_body.dig("error", "code")).to eq(
      "rate_limit_exceeded"
    )
  end

  it "lists all competitions with stable IDs, years, and aggregate counts" do
    credential, token = issue_token(
      [ApiCredential::COMPETITIONS_READ_SCOPE]
    )

    get "/v1/integrations/competitions", headers: authorization(token)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Cache-Control"]).to include("no-store")
    payload = response.parsed_body
    exported = payload["data"].find { |item| item["id"] == competition.id }
    expect(exported).to include(
      "year" => 2026,
      "name" => "National 2026"
    )
    expect(exported["counts"]).to include(
      "participants" => 1,
      "projects" => 1,
      "approved_projects" => 1
    )
    expect(credential.reload).to have_attributes(
      use_count: 1,
      last_used_at: be_present
    )
  end

  it "supports an exact year filter and validates it" do
    _, token = issue_token([ApiCredential::COMPETITIONS_READ_SCOPE])

    get "/v1/integrations/competitions",
      params: {year: 2026},
      headers: authorization(token)

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body["data"].pluck("year")).to eq([2026])

    get "/v1/integrations/competitions",
      params: {year: "not-a-year"},
      headers: authorization(token)

    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.dig("error", "code")).to eq("invalid_year")

    get "/v1/integrations/competitions",
      params: {year: "999999999999999999999"},
      headers: authorization(token)

    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.dig("error", "code")).to eq("invalid_year")
  end

  it "enforces the competition dataset scope" do
    _, token = issue_token([ApiCredential::COMPETITIONS_READ_SCOPE])

    get "/v1/integrations/competition_data",
      params: {competition_id: competition.id},
      headers: authorization(token)

    expect(response).to have_http_status(:forbidden)
    expect(response.parsed_body.dig("error", "required_scope")).to eq(
      ApiCredential::COMPETITION_DATA_READ_SCOPE
    )
  end

  it "exports every participant and project for a competition without PII by default" do
    create(
      :project,
      title: "Waiting project",
      contestants: [participant],
      edition: competition,
      finished: true,
      status: Project::STATUS_REJECTED
    )
    _, token = issue_token([ApiCredential::COMPETITION_DATA_READ_SCOPE])

    get "/v1/integrations/competition_data",
      params: {competition_id: competition.id},
      headers: authorization(token)

    expect(response).to have_http_status(:ok)
    payload = response.parsed_body
    exported_participant = payload.dig("data", "participants").first
    expect(exported_participant).to include(
      "id" => participant.id,
      "name" => "Ana Popescu"
    )
    expect(exported_participant).not_to have_key("personal_data")
    expect(response.body).not_to include(
      "ana@example.com",
      "+40700111222",
      "6060101123456",
      "VX123456"
    )
    expect(payload.dig("data", "projects").pluck("title")).to contain_exactly(
      "Atlas",
      "Waiting project"
    )
    expect(payload.dig("meta", "counts")).to eq(
      "participants" => 1,
      "projects" => 2
    )
  end

  it "accepts a year selector when it resolves to one competition" do
    _, token = issue_token([ApiCredential::COMPETITION_DATA_READ_SCOPE])

    get "/v1/integrations/competition_data",
      params: {year: 2026},
      headers: authorization(token)

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.dig("data", "competition", "id")).to eq(
      competition.id
    )
  end

  it "rejects invalid and out-of-range competition IDs" do
    _, token = issue_token([ApiCredential::COMPETITION_DATA_READ_SCOPE])

    ["-1", "999999999999999999999"].each do |competition_id|
      get "/v1/integrations/competition_data",
        params: {competition_id: competition_id},
        headers: authorization(token)

      expect(response).to have_http_status(:bad_request)
      expect(response.parsed_body.dig("error", "code")).to eq(
        "invalid_competition_id"
      )
    end
  end

  it "requires exactly one unambiguous competition selector" do
    create(:edition, year: 2026, name: "Online 2026", current: false)
    _, token = issue_token([ApiCredential::COMPETITION_DATA_READ_SCOPE])

    get "/v1/integrations/competition_data",
      params: {year: 2026},
      headers: authorization(token)

    expect(response).to have_http_status(:conflict)
    expect(response.parsed_body.dig("error", "code")).to eq("ambiguous_year")

    get "/v1/integrations/competition_data",
      params: {year: 2026, competition_id: competition.id},
      headers: authorization(token)

    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.dig("error", "code")).to eq("invalid_selector")
  end

  it "requires a separate explicit scope before returning personal data" do
    _, token = issue_token([ApiCredential::COMPETITION_DATA_READ_SCOPE])

    get "/v1/integrations/competition_data",
      params: {competition_id: competition.id, include: "personal_data"},
      headers: authorization(token)

    expect(response).to have_http_status(:forbidden)
    expect(response.parsed_body.dig("error", "required_scope")).to eq(
      ApiCredential::PARTICIPANT_PERSONAL_DATA_READ_SCOPE
    )

    _, pii_token = issue_token(
      [
        ApiCredential::COMPETITION_DATA_READ_SCOPE,
        ApiCredential::PARTICIPANT_PERSONAL_DATA_READ_SCOPE
      ]
    )
    get "/v1/integrations/competition_data",
      params: {competition_id: competition.id, include: "personal_data"},
      headers: authorization(pii_token)

    expect(response).to have_http_status(:ok)
    personal_data = response.parsed_body.dig(
      "data",
      "participants",
      0,
      "personal_data"
    )
    expect(personal_data).to include(
      "email" => "ana@example.com",
      "phone_number" => "+40700111222"
    )
    expect(personal_data.dig("identity_document", "national_id")).to eq(
      "6060101123456"
    )
  end

  it "rejects unsupported include values" do
    _, token = issue_token([ApiCredential::COMPETITION_DATA_READ_SCOPE])

    get "/v1/integrations/competition_data",
      params: {competition_id: competition.id, include: "passwords"},
      headers: authorization(token)

    expect(response).to have_http_status(:bad_request)
    expect(response.parsed_body.dig("error", "code")).to eq(
      "unsupported_include"
    )
  end
end
