class Project < ActiveRecord::Base
  scope :active, -> { where(finished: true).where(approved: true) }

  belongs_to :category
  has_many :users, through: :contestants, inverse_of: :projects
  has_many :colaborators, inverse_of: :project, dependent: :destroy
  has_many :contestants, through: :colaborators, inverse_of: :projects
  has_many :screenshots, inverse_of: :project, dependent: :destroy

  accepts_nested_attributes_for :category
  accepts_nested_attributes_for :colaborators,
    :reject_if => :all_blank
  accepts_nested_attributes_for :contestants,
    :reject_if => :all_blank
  accepts_nested_attributes_for :screenshots

  validates :category, presence: true
  validates :contestants, presence: true

  validates :title, presence: true
  validates :description, presence: true
  validates :technical_description, presence: true
  validates :system_requirements, presence: true

  validates :source_url, presence: true, if: Proc.new {
    self.open_source == true
  }

  validates :closed_source_reason, presence: true, if: Proc.new {
    self.open_source == false
  }

  validates :github_username, presence: true, if: Proc.new {
    self.open_source == false
  }

  validates :homepage, presence: true, if: Proc.new { |project|
    !self.category.nil? && self.category.name == "web"
  }

  after_update :update_discourse
  def update_discourse
    discourse = PublishToDiscourse.new
    discourse.update(discourse_title, discourse_content,
                     edition.projects_forum_category,
                     discourse_topic_id) if approved
  end

  after_destroy :delete_discourse
  def delete_discourse
    discourse = PublishToDiscourse.new
    discourse.delete(discourse_topic_id)
  end

  before_validation :initialize_colaborators, on: :create
  def initialize_colaborators
    colaborators.each { |c| c.project = self }
  end

  def name
    "#{title} @ #{edition.name}" if edition
  end

  def edition
    contestants.first.edition if contestants.first
  end

  def county
    contestants.first.county
  end

  def authors
    contestants.map(&:name).join(", ")
  end

  def category_name
    category.name
  end

  def screenshots_count
    screenshots.count
  end

  def discourse_url
    "#{Settings.ui.community_url}/t/#{discourse_topic_id}" if discourse_topic_id
  end

  def discourse_title
    "#{title} - "\
    "#{category.name.capitalize} - "\
    "#{contestants.first.county} - "\
    "#{edition.projects_forum_category}"
  end

  def discourse_content
    template_file = File.open("#{Rails.root}/app/views/discourse/project.erb")
    erb_template = ERB.new(template_file.read, nil, '-')

    context = ERBContext.new(
      category: category.name.capitalize,
      homepage: homepage,
      county: county,
      description: description,
      technical_description: technical_description,
      system_requirements: system_requirements,
      contestants: contestants,
      screenshots: screenshots,
      source_url: source_url,
      open_source: open_source
    )

    erb_template.result(context.get_binding)
  end

  def has_source_url
    not source_url.blank?
  end

  rails_admin do
    show do
      configure :user do
        show
      end
    end
  end
end
