require "rails_helper"

RSpec.describe ApiCredential, type: :model do
  let(:admin) { create(:admin_user) }

  def issue(scopes: [described_class::COMPETITIONS_READ_SCOPE])
    described_class.issue!(
      {
        name: "Partner export",
        scopes: scopes,
        expires_at: 90.days.from_now
      },
      created_by: admin
    )
  end

  it "issues a high-entropy token and stores only its digest" do
    credential, token = issue

    expect(token).to match(described_class::TOKEN_PATTERN)
    expect(credential.secret_digest).to eq(described_class.digest(token))
    expect(credential.secret_digest).not_to include(token)
    expect(credential.attributes.values).not_to include(token)
  end

  it "authenticates the issued token with a constant-time digest comparison" do
    credential, token = issue

    expect(described_class.authenticate(token)).to eq(credential)
    expect(described_class.authenticate("#{token}changed")).to be_nil
    expect(described_class.authenticate("invalid")).to be_nil
  end

  it "rejects revoked and expired credentials" do
    credential, token = issue

    credential.revoke!(by: admin)
    expect(described_class.authenticate(token)).to be_nil

    active_credential, active_token = issue
    described_class.where(id: active_credential.id).update_all(
      expires_at: 1.minute.ago
    )
    expect(described_class.authenticate(active_token)).to be_nil
  end

  it "requires the dataset scope before granting personal data" do
    credential = build(
      :api_credential,
      scopes: [described_class::PARTICIPANT_PERSONAL_DATA_READ_SCOPE]
    )

    expect(credential).not_to be_valid
    expect(credential.errors[:scopes].join).to include(
      described_class::COMPETITION_DATA_READ_SCOPE
    )
  end

  it "rejects unsupported scopes and expiration beyond one year" do
    credential = build(
      :api_credential,
      scopes: ["admin:everything"],
      expires_at: 2.years.from_now
    )

    expect(credential).not_to be_valid
    expect(credential.errors[:scopes].join).to include("unsupported")
    expect(credential.errors[:expires_at]).to include(
      "cannot be more than one year from now"
    )
  end

  it "can only be issued by an administrator" do
    regular_user = create(:confirmed_user)

    expect {
      described_class.issue!(
        {
          name: "Unauthorized issuer",
          scopes: [described_class::COMPETITIONS_READ_SCOPE],
          expires_at: 90.days.from_now
        },
        created_by: regular_user
      )
    }.to raise_error(ActiveRecord::RecordInvalid, /administrator/)
  end

  it "makes issued secrets, scopes, ownership, and expiry immutable" do
    expect(described_class.readonly_attributes).to include(
      "token_identifier",
      "secret_digest",
      "scopes",
      "expires_at",
      "created_by_id"
    )

    credential, = issue
    expect {
      credential.expires_at = 180.days.from_now
    }.to raise_error(ActiveRecord::ReadonlyAttributeError)
    expect {
      credential.scopes = [described_class::COMPETITION_DATA_READ_SCOPE]
    }.to raise_error(ActiveRecord::ReadonlyAttributeError)

    expect {
      credential.update!(description: "Updated owner")
    }.not_to raise_error
  end

  it "records use without changing the stored secret" do
    credential, = issue
    digest = credential.secret_digest

    credential.record_use!(ip: "203.0.113.14")
    credential.reload

    expect(credential).to have_attributes(
      secret_digest: digest,
      use_count: 1,
      last_used_ip: "203.0.113.14"
    )
    expect(credential.last_used_at).to be_present
  end
end
