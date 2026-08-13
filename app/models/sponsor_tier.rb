class SponsorTier < ActiveRecord::Base
  has_many :sponsors,
    -> { order(:position, :title) },
    dependent: :restrict_with_error,
    inverse_of: :sponsor_tier
  has_many :active_sponsors,
    -> { where(active: true).order(:position, :title) },
    class_name: "Sponsor",
    inverse_of: :sponsor_tier

  validates :name, presence: true, uniqueness: true
  validates :position,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :name) }

  def localized_name(locale)
    if locale.to_s.downcase.start_with?("en")
      name_en.presence || name
    else
      name
    end
  end

  def to_s
    name
  end

  rails_admin do
    navigation_label "Community"

    list do
      field :position
      field :name
      field :name_en do
        label "Name (English)"
      end
      field :sponsors
    end

    edit do
      field :name do
        label "Name (Romanian)"
      end
      field :name_en do
        label "Name (English)"
        help "Optional. The Romanian name is used when this is blank."
      end
      field :position do
        help "Lower numbers appear first on the public website."
      end
    end
  end
end
