class Talk < ActiveRecord::Base
  belongs_to :edition, inverse_of: :talks, counter_cache: true
  validates :edition, presence: true

  validates :title, presence: true
  validates :description, presence: true

  validates :date, date: { allow_blank: true }
  validates :topic_id, numericality: { only_integer: true,
                                       greater_than: 0,
                                       allow_blank: true}

  has_many :talk_users, dependent: :destroy
  has_many :users, through: :talk_users
  validates :users, presence: true

  after_create :create_discourse_topic
  def create_discourse_topic
    discourse = PublishToDiscourse.new
    topic_id = discourse.create(discourse_title, discourse_content,
                                edition.talks_forum_category)
    update_attribute(:topic_id, topic_id)
  end

  after_update :update_discourse
  def update_discourse
    discourse = PublishToDiscourse.new
    discourse.update(discourse_title, discourse_content,
                     edition.talks_forum_category,
                     topic_id)
  end

  def name
    "#{title} @ #{edition.name}" if edition
  end

  def topic_created
    !topic_id.nil? && topic_id > 0
  end

  def discourse_url
    "#{Settings.ui.community_url}/t/#{topic_id}" if topic_id
  end

  def discourse_title
    "#{title} - #{edition.talks_forum_category}"
  end

  def discourse_content
    template_file = File.open("#{Rails.root}/app/views/discourse/talk.erb")
    erb_template = ERB.new(template_file.read, nil, '-')

    context = ERBContext.new(
      description: description,
      users: users
    )

    erb_template.result(context.get_binding)
  end

  rails_admin do
    list do
      field :title
      field :location
      field :date
      field :edition
      field :users
      field :topic_created, :boolean
    end
  end
end
