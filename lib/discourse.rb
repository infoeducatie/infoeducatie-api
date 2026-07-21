class Discourse
  class NotConfiguredError < StandardError; end

  def initialize(client = nil)
    @client = client || configured_client
  end

  def configured?
    @client.present?
  end

  def publish(title, raw, category, topic_id = nil)
    raise NotConfiguredError, "Discourse API credentials are not configured" unless configured?

    if topic_id.present?
      begin
        topic = @client.topic(topic_id)
        update_topic(title, raw, category, topic_id, topic)
        return topic_id
      rescue DiscourseApi::NotFoundError
        # A stale local topic ID is replaced below.
      end
    end

    create(title, raw, category)
  end

  def create(title, raw, category)
    return unless configured?

    response = @client.create_topic(
      category: category,
      title: title,
      raw: raw,
      skip_validations: true
    )
    response["topic_id"] || response[:topic_id]
  end

  def update(title, raw, category_id, topic_id)
    return false unless configured?

    topic = @client.topic(topic_id)
    update_topic(title, raw, category_id, topic_id, topic)
  rescue DiscourseApi::NotFoundError
    false
  end

  def recover(topic_id)
    return unless configured?

    @client.put("/t/#{topic_id}/recover.json")
  end

  def delete(topic_id)
    return false if topic_id.blank? || !configured?

    @client.delete_topic(topic_id)
    true
  rescue DiscourseApi::NotFoundError, DiscourseApi::UnauthenticatedError
    false
  end

  def replies_count(topic_id)
    return 0 unless configured?

    topic = @client.topic(topic_id)
    [topic.fetch("posts_count", 1) - 1, 0].max
  rescue DiscourseApi::NotFoundError
    0
  end

  def category(category_id)
    return {"name" => category_id.to_s} unless configured?

    @client.category(category_id)
  rescue DiscourseApi::NotFoundError
    {"name" => category_id.to_s}
  end

  private

  def update_topic(title, raw, category_id, topic_id, topic)
    post = topic.dig("post_stream", "posts")&.first
    return false unless post && post["username"] == @client.api_username

    begin
      @client.rename_topic(topic_id, title)
    rescue DiscourseApi::UnauthenticatedError
      recover(topic_id)
      @client.rename_topic(topic_id, title)
    end

    @client.edit_post(post["id"], raw)
    @client.recategorize_topic(topic_id, category_id)
    true
  end

  def configured_client
    api_key = ENV["DISCOURSE_API"]
    api_username = ENV["DISCOURSE_USER"]
    return if api_key.blank? || api_username.blank?

    DiscourseApi::Client.new(
      Settings.ui.community_url,
      api_key,
      api_username
    )
  end
end
