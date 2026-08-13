class JuryCategory < ActiveRecord::Base
  has_many :jury_members,
    -> { order(:position, :name) },
    dependent: :restrict_with_error,
    inverse_of: :jury_category
  has_many :active_jury_members,
    -> { where(active: true).order(:position, :name) },
    class_name: "JuryMember",
    inverse_of: :jury_category

  mount_uploader :icon, JuryIconUploader

  validates :title, presence: true, uniqueness: true
  validates :title_en, presence: true
  validates :position,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :title) }

  def localized_title(locale)
    english_locale?(locale) ? title_en.presence || title : title
  end

  def to_s
    title
  end

  rails_admin do
    navigation_label "Community"

    configure :icon, :carrierwave

    list do
      field :position
      field :title
      field :title_en do
        label "Title (English)"
      end
      field :icon
      field :active
      field :jury_members
    end

    edit do
      field :title do
        label "Title (Romanian)"
      end
      field :title_en do
        label "Title (English)"
      end
      field :icon do
        html_attributes accept: "image/jpeg,image/png,image/webp"
        help "Optional. JPEG, PNG or WebP, up to 2 MB."
      end
      field :position do
        help "Lower numbers appear first on the public website."
      end
      field :active do
        help "Inactive categories remain in the dashboard but are hidden publicly."
      end
    end
  end

  private

  def english_locale?(locale)
    locale.to_s.downcase.start_with?("en")
  end
end
