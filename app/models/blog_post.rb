class BlogPost < ActiveRecord::Base
  validates :slug,
    presence: true,
    uniqueness: true,
    format: {with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/}
  validates :title, :excerpt, :body, :author_name, :published_at, presence: true

  with_options if: :english_content_present? do
    validates :title_en, presence: true
    validates :body_en, presence: true
  end

  scope :published, -> {
    where(active: true).where("published_at <= ?", Time.current)
  }
  scope :newest_first, -> { order(published_at: :desc, id: :desc) }

  def localized_title(locale)
    english_locale?(locale) ? title_en.presence || title : title
  end

  def localized_excerpt(locale)
    english_locale?(locale) ? excerpt_en.presence || excerpt : excerpt
  end

  def localized_body(locale)
    english_locale?(locale) ? body_en.presence || body : body
  end

  def localized_category(locale)
    english_locale?(locale) ? category_en.presence || category : category
  end

  def to_s
    title
  end

  rails_admin do
    label "Blog post"
    label_plural "Blog posts"
    navigation_label "Community"

    list do
      field :title
      field :author_name
      field :category
      field :published_at
      field :active
    end

    edit do
      field :slug do
        help "Stable public identifier. Use lowercase letters, numbers and hyphens."
      end
      field :title do
        label "Title (Romanian)"
      end
      field :title_en do
        label "Title (English)"
        help "Optional. Romanian content is used when the English translation is blank."
      end
      field :excerpt do
        label "Excerpt (Romanian)"
        help "Short plain-text introduction shown in the blog listing."
      end
      field :excerpt_en do
        label "Excerpt (English)"
        help "Optional. The Romanian excerpt is used when this is blank."
      end
      field :body do
        partial :form_rich_text_editor
        label "Body (Romanian)"
        help "Formatted Romanian article content. Images are uploaded securely when attached."
      end
      field :body_en do
        partial :form_rich_text_editor
        label "Body (English)"
        help "Optional formatted English article content."
      end
      field :author_name do
        help "Public author name displayed with the article."
      end
      field :category do
        label "Category (Romanian)"
      end
      field :category_en do
        label "Category (English)"
        help "Optional. The Romanian category is used when this is blank."
      end
      field :published_at do
        help "The article becomes public at this date and time when active."
      end
      field :active do
        help "Inactive posts remain in the dashboard but are hidden from the public API."
      end
    end
  end

  private

  def english_content_present?
    title_en.present? || excerpt_en.present? || body_en.present? ||
      category_en.present?
  end

  def english_locale?(locale)
    locale.to_s.downcase.start_with?("en")
  end
end
