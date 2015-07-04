class PublishToDiscourse

  def initialize(project)
    @project = project

    @client = DiscourseApi::Client.new(Settings.ui.community_url)
    @client.api_key = ENV["DISCOURSE_API"]
    @client.api_username = ENV["DISCOURSE_USER"]
  end

  def publish!
    title = "#{@project.title} - #{@project.category.name.capitalize} - #{@project.contestants.first.county} - #{@project.edition.projects_forum_category}"

    # prepare raw value
    # 1. read ERB template and create ERB object
    template_file = File.open("#{Rails.root}/app/views/discourse/template.erb")
    erb_template = ERB.new(template_file.read)

    # 2. Create necessary context
    context = ERBContext.new(
      category: @project.category.name.capitalize,
      homepage: @project.homepage,
      county: @project.county,
      description: @project.description,
      technical_description: @project.technical_description,
      system_requirements: @project.system_requirements,
      contestants: @project.contestants,
      screenshots: @project.screenshots
    )

    # 3. Render template
    raw = erb_template.result(context.get_binding)

    @client.create_topic(
      category: @project.edition.projects_forum_category,
      title: title,
      raw: raw
    )
  end
end

# wrap around the variables that need to populate the paiload sent to discourse
class ERBContext
  def initialize(hash)
    hash.each_pair do |key, value|
      instance_variable_set('@' + key.to_s, value)
    end
  end

  def get_binding
    binding
  end
end
