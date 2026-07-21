class Talk < ActiveRecord::Base
  DISCOURSE_SYNC_ATTRIBUTES = %w[title description edition_id].freeze

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

  after_commit :create_discourse_topic, on: :create

  def create_discourse_topic
    discourse = Discourse.new
    topic_id = discourse.create(discourse_title, discourse_content,
                                edition.talks_forum_category)
    update_column(:topic_id, topic_id) if topic_id.present?
  rescue DiscourseApi::DiscourseError => error
    report_discourse_error("create", error)
  end

  after_commit :update_discourse, on: :update, if: :discourse_sync_required?

  def discourse_sync_required?
    topic_id.present? && (previous_changes.keys & DISCOURSE_SYNC_ATTRIBUTES).any?
  end

  def update_discourse
    return false if topic_id.nil? || edition.nil?

    discourse = Discourse.new
    discourse.update(discourse_title, discourse_content,
                     edition.talks_forum_category,
                     topic_id)
  rescue DiscourseApi::DiscourseError => error
    report_discourse_error("sync", error)
  end

  after_commit :delete_discourse, on: :destroy

  def delete_discourse
    Discourse.new.delete(topic_id)
  rescue DiscourseApi::DiscourseError => error
    report_discourse_error("delete", error)
  end

  def name
    "#{title} @ #{edition.name}" if edition
  end

  def discourse_url
    "#{Settings.ui.community_url}/t/#{topic_id}" if topic_id
  end

  def discourse_title
    discourse = Discourse.new
    discourse_category = discourse.category(edition.talks_forum_category)

    "#{title} - #{discourse_category['name']}"
  end

  def discourse_content
    template = Rails.root.join("app/views/discourse/talk.erb").read
    erb_template = ERB.new(template, trim_mode: "-")

    context = ErbContext.new(
      description: description,
      users: users
    )

    erb_template.result(context.get_binding)
  end

  private

  def report_discourse_error(operation, error)
    Rails.logger.error(
      "Talk Discourse #{operation} failed for talk=#{id}: " \
      "#{error.class}: #{error.message}"
    )
    Sentry.capture_exception(error)
    false
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
