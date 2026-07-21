class ProjectsTopicField < ActiveRecord::Migration[4.2]
  def change
    rename_column :projects, :discourse_topic_id, :topic_id
  end
end
