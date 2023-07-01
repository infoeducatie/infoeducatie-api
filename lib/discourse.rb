class Discourse

  def initialize
    @client = DiscourseApi::Client.new(Settings.ui.community_url)
    @client.api_key = ENV["DISCOURSE_API"]
    @client.api_username = ENV["DISCOURSE_USER"]

    @client = nil if @client.api_key.blank? or @client.api_username.blank?
  end

  def publish(title, raw, category, topic_id = nil)
    return 1 if @client.nil?

    unless topic_id.nil?
      topic = @client.topic(topic_id)
      if topic.has_key?("errors")
        topic_id = nil
      else
        update(title, raw, category, topic_id)
      end
    end

    topic_id = create(title, raw, category) if topic_id.nil?
    topic_id
  end

  def create(title, raw, category)
    return 1 if @client.nil?
    @client.create_topic(
      category: category,
      title: title,
      raw: raw,
      skip_validations: true
    )["topic_id"]
  end

  def update(title, raw, category_id, topic_id)
    return if @client.nil?

    topic = @client.topic(topic_id)
    return if topic.has_key?("errors")

    post = topic["post_stream"]["posts"][0]
    return if post["username"] != @client.api_username

    begin
      @client.rename_topic(topic_id, title)
    rescue DiscourseApi::UnauthenticatedError
      recover(topic_id)
      @client.rename_topic(topic_id, title)
    end

    @client.edit_post(post["id"], raw)
    @client.recategorize_topic(topic_id, category_id)
  end

  def recover(topic_id)
    return if @client.nil?
    @client.put("/t/#{topic_id}/recover.json")
  end

  def delete(topic_id)
    return if topic_id.nil?
    return if @client.nil?
    suppress(DiscourseApi::UnauthenticatedError) do
      @client.delete_topic(topic_id)
    end
  end

  def replies_count(topic_id)
    topic = @client.topic(topic_id)
    return 0 if topic["posts_count"].nil?
    return topic["posts_count"] - 1
  end

  def category(category_id)
    return @client.category(category_id)
  end
end
