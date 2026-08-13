require "uri"

class PhotoAlbum < ActiveRecord::Base
  mount_uploader :cover_image, PhotoAlbumCoverUploader

  validates :title, presence: true
  validates :external_url, presence: true
  validates :cover_image, presence: true
  validates :position,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :external_url_uses_http

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :title) }

  def localized_title(locale)
    if locale.to_s.downcase.start_with?("en")
      title_en.presence || title
    else
      title
    end
  end

  def to_s
    title
  end

  rails_admin do
    label "Photo album"
    label_plural "Photo albums"
    navigation_label "Community"

    configure :cover_image, :carrierwave

    list do
      field :position
      field :title
      field :title_en do
        label "Title (English)"
      end
      field :cover_image
      field :external_url
      field :active
    end

    edit do
      field :title do
        label "Title (Romanian)"
        help "Required public title, such as a year or event name."
      end
      field :title_en do
        label "Title (English)"
        help "Optional. The Romanian title is used as a fallback."
      end
      field :external_url do
        help "Required public HTTP or HTTPS link opened when the album is selected."
        html_attributes autocomplete: "url"
      end
      field :cover_image do
        html_attributes accept: "image/jpeg,image/png,image/webp"
        help "Required. JPEG, PNG or WebP, up to 5 MB. Displayed at a 4:3 ratio."
      end
      field :position do
        help "Lower numbers appear first on the public website."
      end
      field :active do
        help "Inactive albums remain in the dashboard but are hidden publicly."
      end
    end
  end

  private

  def external_url_uses_http
    return if external_url.blank?

    uri = URI.parse(external_url)
    return if uri.is_a?(URI::HTTP) && uri.host.present?

    errors.add(:external_url, "must be a complete HTTP or HTTPS URL")
  rescue URI::InvalidURIError
    errors.add(:external_url, "must be a complete HTTP or HTTPS URL")
  end
end
