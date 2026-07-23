FactoryBot.define do
  factory :api_credential do
    name { "Results integration" }
    description { "Used by an external results dashboard" }
    token_identifier { SecureRandom.hex(ApiCredential::TOKEN_IDENTIFIER_BYTES) }
    secret_digest { "a" * 64 }
    scopes {
      [
        ApiCredential::COMPETITIONS_READ_SCOPE,
        ApiCredential::COMPETITION_DATA_READ_SCOPE
      ]
    }
    expires_at { 90.days.from_now }
    association :created_by, factory: :admin_user
  end
end
