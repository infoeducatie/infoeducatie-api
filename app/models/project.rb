class Project < ActiveRecord::Base
  STATUS_APPROVED = 1
  STATUS_REJECTED = -1
  STATUS_WAITING  = 0

  scope :approved, -> { where(finished: true)
                      .where(status: Project::STATUS_APPROVED) }

  scope :rejected, -> { where(finished: true)
                      .where(status: Project::STATUS_REJECTED) }

  scope :waiting, -> { where(finished: true)
                     .where(status: Project::STATUS_WAITING)}

  scope :finished, -> { where(finished: true) }
  scope :unfinished, -> { where(finished: false) }

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

  validates :score, presence: true
  validates :extra_score, presence: true

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

  before_save :update_total_score
  def update_total_score
    self.total_score = score + extra_score
  end

  after_update :update_discourse
  def update_discourse
    return if topic_id.nil?
    discourse = Discourse.new
    discourse.update(discourse_title, discourse_content,
                     edition.projects_forum_category,
                     topic_id) if status == Project::STATUS_APPROVED
  end

  after_destroy :delete_discourse
  def delete_discourse
    discourse = Discourse.new
    discourse.delete(topic_id)
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

  def counties
    contestants.map do |contestant|
      contestant.county
    end.uniq
  end

  def counties_str
    counties.join(", ")
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
    "#{Settings.ui.community_url}/t/#{topic_id}" if topic_id
  end

  def discourse_title
    "#{title} - "\
    "#{category.name.capitalize} - "\
    "#{counties.join(" ")} - "\
    "#{edition.projects_forum_category}"
  end

  def discourse_content
    template_file = File.open("#{Rails.root}/app/views/discourse/project.erb")
    erb_template = ERB.new(template_file.read, nil, '-')

    context = ERBContext.new(
      category: category.name.capitalize,
      homepage: homepage,
      county: counties.join(" "),
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

    list do
      scopes [:approved, :waiting, :unfinished, :rejected]
      field :title
      field :users do
        searchable [:first_name, :last_name, :email]
      end
      field :category_name
      field :counties_str do
        label "County"
      end
      field :total_score
      field :open_source do
        label "Open"
        column_width 60
      end
      field :has_source_url, :boolean do
        label "Repository"
        column_width 90
      end
    end

    edit do
      field :title
      field :description
      field :technical_description
      field :system_requirements
      field :open_source
      field :source_url
      field :homepage
      field :closed_source_reason
      field :github_username

      field :category do
        nested_form false
      end

      field :contestants do
        nested_form false
      end

      field :score
      field :extra_score
      field :prize
    end
  end

end
