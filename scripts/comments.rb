discourse = Discourse.new

projects = Project.approved
                  .joins(:contestants)
                  .where(contestants: { edition: Edition.get_current })
                  .distinct

projects.each do |project|
  project.update_column(:comments_count,
                        discourse.replies_count(project.topic_id))
end

talks = Talk.where(edition: Edition.get_current)

talks.each do |talk|
  talk.update_column(:comments_count, discourse.replies_count(talk.topic_id))
end
