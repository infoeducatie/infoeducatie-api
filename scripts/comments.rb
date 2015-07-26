discourse = Discourse.new

projects = Project.approved
                  .joins(:contestants)
                  .where(contestants: { edition: Edition.get_current })
                  .distinct

projects.each do |project|
  project.comments_count = discourse.replies_count(project.discourse_topic_id)
  project.save!
end

talks = Talk.where(edition: Edition.get_current)

talks.each do |talk|
  talk.comments_count = discourse.replies_count(talk.topic_id)
  talk.save!
end
