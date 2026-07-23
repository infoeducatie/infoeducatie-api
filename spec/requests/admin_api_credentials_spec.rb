require "rails_helper"

RSpec.describe "RailsAdmin API credentials", type: :request do
  let(:admin) { create(:admin_user) }

  before do
    sign_in admin
  end

  it "renders the API key index without exposing secret digests" do
    credential = create(:api_credential, secret_digest: "b" * 64)

    get "/internal/admin/api_credential"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(credential.name)
    expect(response.body).not_to include(credential.secret_digest)
  end

  it "does not create a key on GET" do
    expect {
      get "/internal/admin/api_credential/issue_api_credential"
    }.not_to change(ApiCredential, :count)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Issue a new API key")
    expect(response.body).to include('data-turbo="false"')
  end

  it "issues a scoped key, shows it once, and prevents response caching" do
    expect {
      post "/internal/admin/api_credential/issue_api_credential",
        params: {
          api_credential: {
            name: "External scoreboard",
            description: "Owned by the scoreboard team",
            expires_at: 90.days.from_now.strftime("%Y-%m-%dT%H:%M"),
            scopes: [
              ApiCredential::COMPETITIONS_READ_SCOPE,
              ApiCredential::COMPETITION_DATA_READ_SCOPE
            ]
          }
        }
    }.to change(ApiCredential, :count).by(1)

    expect(response).to have_http_status(:ok)
    expect(response.headers["Cache-Control"]).to include("no-store")
    token = response.body[
      /ie_api_[0-9a-f]{16}\.[A-Za-z0-9_-]{43}/
    ]
    expect(token).to be_present

    credential = ApiCredential.order(:id).last
    expect(credential).to have_attributes(
      name: "External scoreboard",
      created_by: admin
    )
    expect(ApiCredential.authenticate(token)).to eq(credential)

    get "/internal/admin/api_credential/#{credential.id}"
    expect(response.body).not_to include(token)
    expect(response.body).not_to include(credential.secret_digest)
  end

  it "renders validation errors without persisting a credential" do
    expect {
      post "/internal/admin/api_credential/issue_api_credential",
        params: {
          api_credential: {
            name: "Invalid key",
            expires_at: 90.days.from_now.strftime("%Y-%m-%dT%H:%M"),
            scopes: [ApiCredential::PARTICIPANT_PERSONAL_DATA_READ_SCOPE]
          }
        }
    }.not_to change(ApiCredential, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("requires")
  end

  it "requires POST to revoke a key and records the administrator" do
    credential = create(:api_credential)

    get "/internal/admin/api_credential/#{credential.id}/revoke_api_credential"
    expect(response).to have_http_status(:ok)
    expect(credential.reload.revoked_at).to be_nil

    post "/internal/admin/api_credential/#{credential.id}/revoke_api_credential"
    expect(response).to have_http_status(:redirect)
    expect(credential.reload).to have_attributes(
      revoked_by: admin,
      status: "revoked"
    )
  end
end
