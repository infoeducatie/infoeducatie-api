class PublishToDiscourse

  def initialize
    @client = DiscourseApi::Client.new(Settings.ui.community_url)
    @client.api_key = ENV["DISCOURSE_API"]
    @client.api_username = ENV["DISCOURSE_USER"]
  end

  def publish(title, raw, category, topic_id = nil)
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
    @client.create_topic(
      category: category,
      title: title,
      raw: raw,
      skip_validations: true
    )["topic_id"]
  end

  def update(title, raw, category, topic_id)
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

    category = @client.category(sanitize_slug(category))
    unless category.has_key?("errors")
      @client.recategorize_topic(topic_id, category["id"])
    end
  end

  def recover(topic_id)
    @client.put("/t/#{topic_id}/recover.json")
  end

  private
    # https://github.com/discourse/discourse/blob/master/lib/slug.rb
    def sanitize_slug(string)
      string.strip
          .gsub(/\s+/, '-')
          .gsub(/[:\/\?#\[\]@!\$&'\(\)\*\+,;=_\.~%\\`^\s|\{\}"<>]+/, '') # :/?#[]@!$&'()*+,;=_.~%\`^|{}"<>
          .gsub(/\A-+|-+\z/, '') # remove possible trailing and preceding dashes
          .squeeze('-') # squeeze continuous dashes to prettify slug
          .downcase
    end
end
