class Talk < ActiveRecord::Base
  belongs_to :edition, inverse_of: :talks, counter_cache: true
  validates :edition, presence: true

  validates :title, presence: true
  validates :description, presence: true

  validates :topic_id, numericality: { only_integer: true,
                                       greater_than: 0,
                                       allow_blank: true}

  has_many :talk_users, dependent: :destroy
  has_many :users, through: :talk_users
  validates :users, presence: true

  after_create :create_discourse_topic, :update_mailchimp
  def create_discourse_topic
    discourse = Discourse.new
    topic_id = discourse.create(discourse_title, discourse_content,
                                edition.talks_forum_category)
    update_attribute(:topic_id, topic_id)
  end

  def update_mailchimp
    users.each do |user|
      user.update_mailchimp
    end
  end

  after_update :update_discourse
  def update_discourse
    return if topic_id.nil?
    discourse = Discourse.new
    discourse.update(discourse_title, discourse_content,
                     edition.talks_forum_category,
                     topic_id)
  end

  after_destroy :delete_discourse
  def delete_discourse
    discourse = Discourse.new
    discourse.delete(topic_id)
  end

  def name
    "#{title} @ #{edition.name}" if edition
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
      field :edition
      field :users do
        searchable [:first_name, :last_name, :email]
      end
    end
    edit do
      field :title
      field :description
      field :edition
      field :users
    end
    show do
      field :title
      field :description
      field :edition
      field :users
      field :discourse_url
    end
  end
end
