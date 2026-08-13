require "uri"

class Sponsor < ActiveRecord::Base
  belongs_to :sponsor_tier, inverse_of: :sponsors

  mount_uploader :image, SponsorImageUploader

  validates :title, presence: true
  validates :sponsor_tier, presence: true
  validates :image, presence: true
  validates :position,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :website_url_uses_http

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :title) }

  rails_admin do
    navigation_label "Community"

    configure :image, :carrierwave

    list do
      field :position
      field :title
      field :sponsor_tier
      field :image
      field :website_url
      field :active
    end

    edit do
      field :title
      field :sponsor_tier
      field :image do
        html_attributes accept: "image/jpeg,image/png,image/webp"
        help "Required. JPEG, PNG or WebP, up to 5 MB."
      end
      field :website_url do
        help "Optional public HTTP or HTTPS link opened when the logo is selected."
        html_attributes autocomplete: "url"
      end
      field :position do
        help "Lower numbers appear first inside the selected tier."
      end
      field :active do
        help "Inactive sponsors remain in the dashboard but are hidden publicly."
      end
    end
  end

  private

  def website_url_uses_http
    return if website_url.blank?

    uri = URI.parse(website_url)
    return if uri.is_a?(URI::HTTP) && uri.host.present?

    errors.add(:website_url, "must be a complete HTTP or HTTPS URL")
  rescue URI::InvalidURIError
    errors.add(:website_url, "must be a complete HTTP or HTTPS URL")
  end
end
