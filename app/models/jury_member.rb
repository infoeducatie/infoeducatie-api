class JuryMember < ActiveRecord::Base
  belongs_to :jury_category, inverse_of: :jury_members

  mount_uploader :photo, JuryPhotoUploader

  validates :jury_category, presence: true
  validates :name, presence: true
  validates :photo, presence: true
  validates :occupation, presence: true
  validates :position,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :name) }

  def localized_title(locale)
    english_locale?(locale) ? title_en.presence || title : title
  end

  def localized_occupation(locale)
    english_locale?(locale) ? occupation_en.presence || occupation : occupation
  end

  def to_s
    name
  end

  rails_admin do
    navigation_label "Community"

    configure :photo, :carrierwave

    list do
      field :position
      field :name
      field :title
      field :jury_category
      field :occupation
      field :photo
      field :active
    end

    edit do
      field :jury_category
      field :title do
        label "Title (Romanian)"
        help "Optional, for example President or Vice president."
      end
      field :title_en do
        label "Title (English)"
        help "Optional. Romanian content is used when this is blank."
      end
      field :name
      field :photo do
        html_attributes accept: "image/jpeg,image/png,image/webp"
        help "Required. JPEG, PNG or WebP, up to 5 MB."
      end
      field :occupation do
        label "Occupation (Romanian)"
      end
      field :occupation_en do
        label "Occupation (English)"
        help "Optional. Romanian content is used when this is blank."
      end
      field :position do
        help "Lower numbers appear first inside the selected category."
      end
      field :active do
        help "Inactive members remain in the dashboard but are hidden publicly."
      end
    end
  end

  private

  def english_locale?(locale)
    locale.to_s.downcase.start_with?("en")
  end
end
