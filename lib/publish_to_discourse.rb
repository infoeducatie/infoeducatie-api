class PublishToDiscourse

  def initialize
    @client = DiscourseApi::Client.new(Settings.ui.community_url)
    @client.api_key = ENV["DISCOURSE_API"]
    @client.api_username = ENV["DISCOURSE_USER"]
  end

  def publish(title, raw, category, topic_id = nil)
    unless topic_id.nil?
      topic = @client.topic(topic_id)
      if topic.nil?
        topic_id = nil
      else
        update(title, raw, topic_id)
      end
    end

    topic_id = create(title, raw, category) if topic_id.nil?
    topic_id
  end

  def create(title, raw, category)
    @client.create_topic(
      category: category,
      title: title,
      raw: raw
    )["topic_id"]
  end

  def update(title, raw, topic_id)
    topic = @client.topic(topic_id)
    return if topic.nil?

    post = topic["post_stream"]["posts"][0]
    return if post["username"] != @client.api_username

    begin
      @client.rename_topic(topic_id, title)
      @client.edit_post(post["id"], raw)
    rescue DiscourseApi::UnauthenticatedError
      recover(topic_id)
      @client.rename_topic(topic_id, title)
      @client.edit_post(post["id"], raw)
    end
  end

  def recover(topic_id)
    @client.put("/t/#{topic_id}/recover.json")
  end
end
