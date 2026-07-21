require "rails_helper"

RSpec.describe "Request security", type: :request do
  let(:user) { create(:confirmed_user) }

  it "accepts the legacy raw authorization token" do
    get "/v1/current", headers: {"Authorization" => user.access_token}

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include("is_logged_in" => true)
  end

  it "accepts a Bearer authorization token" do
    get "/v1/current", headers: {"Authorization" => "Bearer #{user.access_token}"}

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include("is_logged_in" => true)
  end

  it "does not authenticate a malformed token" do
    get "/v1/current", headers: {"Authorization" => "Bearer #{user.id}:invalid"}

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include("is_logged_in" => false)
  end

  it "allows CORS preflight only from the configured UI" do
    options "/v1/projects",
      headers: {
        "Origin" => "http://localhost:8080",
        "Access-Control-Request-Method" => "POST"
      }

    expect(response).to have_http_status(:ok)
    expect(response.headers["Access-Control-Allow-Origin"])
      .to eq("http://localhost:8080")
  end

  it "does not grant CORS access to arbitrary origins" do
    options "/v1/projects",
      headers: {
        "Origin" => "https://example.invalid",
        "Access-Control-Request-Method" => "POST"
      }

    expect(response.headers).not_to include("Access-Control-Allow-Origin")
  end

  it "exposes a container health check" do
    get "/up"

    expect(response).to have_http_status(:ok)
  end
end
