class ContentPage < ActiveRecord::Base
  mount_uploader :document, ContentPageDocumentUploader
  mount_uploader :document_en, ContentPageDocumentUploader

  validates :slug,
    presence: true,
    uniqueness: true,
    format: {with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/}
  validates :title, presence: true
  validates :body, presence: true

  with_options if: :english_content_present? do
    validates :title_en, presence: true
    validates :body_en, presence: true
  end

  scope :active, -> { where(active: true) }

  def localized_title(locale)
    english_locale?(locale) ? title_en.presence || title : title
  end

  def localized_body(locale)
    english_locale?(locale) ? body_en.presence || body : body
  end

  def localized_document_url(locale)
    if english_locale?(locale) && document_en?
      document_en.url
    elsif document?
      document.url
    end
  end

  def to_s
    title
  end

  rails_admin do
    label "Content page"
    label_plural "Content pages"
    navigation_label "Community"

    configure :document, :carrierwave
    configure :document_en, :carrierwave

    list do
      field :title
      field :slug
      field :active
      field :updated_at
    end

    edit do
      field :title do
        label "Title (Romanian)"
      end
      field :title_en do
        label "Title (English)"
        help "Optional. Romanian content is used when the English translation is blank."
      end
      field :body do
        partial :form_rich_text_editor
        label "Body (Romanian)"
        help "Formatted Romanian page content. Images are uploaded securely when attached."
      end
      field :body_en do
        partial :form_rich_text_editor
        label "Body (English)"
        help "Optional formatted English page content."
      end
      field :document do
        label "Document (Romanian)"
        html_attributes accept: "application/pdf"
        help "Optional. PDF, up to 10 MB."
      end
      field :document_en do
        label "Document (English)"
        html_attributes accept: "application/pdf"
        help "Optional. The Romanian document is used when this is blank. PDF, up to 10 MB."
      end
    end
  end

  private

  def english_content_present?
    title_en.present? || body_en.present?
  end

  def english_locale?(locale)
    locale.to_s.downcase.start_with?("en")
  end
end
