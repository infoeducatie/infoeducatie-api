class ApiCredential < ActiveRecord::Base
  TOKEN_PREFIX = "ie_api_"
  TOKEN_IDENTIFIER_BYTES = 8
  TOKEN_SECRET_BYTES = 32
  TOKEN_PATTERN = /\Aie_api_([0-9a-f]{16})\.([A-Za-z0-9_-]{43})\z/
  MAX_LIFETIME = 1.year

  COMPETITIONS_READ_SCOPE = "competitions:read"
  COMPETITION_DATA_READ_SCOPE = "competition_data:read"
  PARTICIPANT_PERSONAL_DATA_READ_SCOPE = "participants:personal_data:read"

  AVAILABLE_SCOPES = {
    COMPETITIONS_READ_SCOPE => "List competitions and years",
    COMPETITION_DATA_READ_SCOPE => "Read participants and projects for a competition",
    PARTICIPANT_PERSONAL_DATA_READ_SCOPE =>
      "Read sensitive participant contact and identity data"
  }.freeze

  belongs_to :created_by,
    class_name: "User",
    inverse_of: :created_api_credentials,
    optional: true
  belongs_to :revoked_by,
    class_name: "User",
    inverse_of: :revoked_api_credentials,
    optional: true

  before_validation :normalize_attributes

  validates :name, presence: true, length: {maximum: 120}
  validates :description, length: {maximum: 1_000}, allow_blank: true
  validates :created_by, presence: true, on: :create
  validate :created_by_is_an_administrator, on: :create
  validates :token_identifier,
    presence: true,
    uniqueness: true,
    format: {with: /\A[0-9a-f]{16}\z/}
  validates :secret_digest,
    presence: true,
    format: {with: /\A[0-9a-f]{64}\z/}
  validates :scopes, presence: true
  validates :expires_at, presence: true
  validate :scopes_are_supported
  validate :personal_data_scope_has_dataset_scope
  validate :expiry_is_safe, on: :create

  attr_readonly :token_identifier,
    :secret_digest,
    :scopes,
    :expires_at,
    :created_by_id

  scope :active, -> {
    where(revoked_at: nil).where("expires_at > ?", Time.current)
  }

  def self.issue!(attributes, created_by:)
    token_identifier = SecureRandom.hex(TOKEN_IDENTIFIER_BYTES)
    secret = SecureRandom.urlsafe_base64(TOKEN_SECRET_BYTES, false)
    plaintext_token = "#{TOKEN_PREFIX}#{token_identifier}.#{secret}"

    credential = create!(
      attributes.merge(
        token_identifier: token_identifier,
        secret_digest: digest(plaintext_token),
        created_by: created_by
      )
    )

    [credential, plaintext_token]
  end

  def self.authenticate(plaintext_token)
    token = plaintext_token.to_s
    return if token.bytesize > 256

    match = TOKEN_PATTERN.match(token)
    return unless match

    credential = find_by(token_identifier: match[1])
    return unless credential&.active?

    supplied_digest = digest(token)
    stored_digest = credential.secret_digest.to_s
    return unless supplied_digest.bytesize == stored_digest.bytesize
    return unless ActiveSupport::SecurityUtils.secure_compare(
      supplied_digest,
      stored_digest
    )

    credential
  end

  def self.digest(plaintext_token)
    OpenSSL::HMAC.hexdigest(
      "SHA256",
      ENV["API_KEY_PEPPER"].presence || Rails.application.secret_key_base,
      plaintext_token
    )
  end

  def active?
    revoked_at.nil? && expires_at.future?
  end

  def revoked?
    revoked_at.present?
  end

  def expired?
    !revoked? && expires_at.past?
  end

  def status
    return "revoked" if revoked?
    return "expired" if expired?

    "active"
  end

  def allows?(scope)
    scopes.include?(scope)
  end

  def masked_token
    "#{TOKEN_PREFIX}#{token_identifier}..."
  end

  def scope_names
    scopes.join(", ")
  end

  def revoke!(by:)
    with_lock do
      return self if revoked?

      update_columns(
        revoked_at: Time.current,
        revoked_by_id: by&.id,
        updated_at: Time.current
      )
    end

    self
  end

  def record_use!(ip:)
    now = Time.current
    safe_ip = ip.to_s.first(45)

    self.class.where(id: id).update_all(
      [
        "use_count = use_count + 1, last_used_at = ?, last_used_ip = ?",
        now,
        safe_ip
      ]
    )

    self.last_used_at = now
    self.last_used_ip = safe_ip
    self.use_count += 1
  end

  rails_admin do
    label "API key"
    label_plural "API keys"
    navigation_label "Security"
    object_label_method :name

    list do
      field :name
      field :masked_token do
        label "Key"
      end
      field :status
      field :scope_names do
        label "Scopes"
      end
      field :expires_at
      field :last_used_at
      field :use_count
    end

    show do
      field :name
      field :description
      field :masked_token do
        label "Key"
      end
      field :status
      field :scope_names do
        label "Scopes"
      end
      field :expires_at
      field :created_by
      field :created_at
      field :revoked_at
      field :revoked_by
      field :last_used_at
      field :last_used_ip
      field :use_count
    end
  end

  private

  def normalize_attributes
    self.name = name.to_s.strip
    self.description = description.to_s.strip.presence
    return if persisted?

    self.scopes = Array(scopes).filter_map do |scope|
      normalized_scope = scope.to_s.strip
      normalized_scope.presence
    end.uniq.sort
  end

  def scopes_are_supported
    unsupported_scopes = scopes - AVAILABLE_SCOPES.keys
    return if unsupported_scopes.empty?

    errors.add(:scopes, "include unsupported values: #{unsupported_scopes.join(", ")}")
  end

  def created_by_is_an_administrator
    return if created_by&.admin?

    errors.add(:created_by, "must be an administrator")
  end

  def personal_data_scope_has_dataset_scope
    return unless scopes.include?(PARTICIPANT_PERSONAL_DATA_READ_SCOPE)
    return if scopes.include?(COMPETITION_DATA_READ_SCOPE)

    errors.add(
      :scopes,
      "#{PARTICIPANT_PERSONAL_DATA_READ_SCOPE} requires " \
        "#{COMPETITION_DATA_READ_SCOPE}"
    )
  end

  def expiry_is_safe
    return if expires_at.blank?

    errors.add(:expires_at, "must be in the future") unless expires_at.future?
    if expires_at > MAX_LIFETIME.from_now
      errors.add(:expires_at, "cannot be more than one year from now")
    end
  end
end
