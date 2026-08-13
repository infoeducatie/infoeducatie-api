class JudgingCriterion < ActiveRecord::Base
  self.table_name = "judging_criteria"

  mount_uploader :document, JudgingCriterionDocumentUploader

  validates :title, presence: true, uniqueness: true
  validates :title_en, presence: true
  validates :document, presence: true
  validates :position,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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
    label "Judging criterion"
    label_plural "Judging criteria"
    navigation_label "Community"

    configure :document, :carrierwave

    list do
      field :position
      field :title
      field :title_en do
        label "Title (English)"
      end
      field :document
      field :active
    end

    edit do
      field :title do
        label "Title (Romanian)"
      end
      field :title_en do
        label "Title (English)"
      end
      field :document do
        html_attributes accept: "application/pdf"
        help "Required. PDF, up to 10 MB."
      end
      field :position do
        help "Lower numbers appear first on the public website."
      end
      field :active do
        help "Inactive criteria remain in the dashboard but are hidden publicly."
      end
    end
  end
end
