class ProjectsTopicField < ActiveRecord::Migration
  def change
    rename_column :projects, :discourse_topic_id, :topic_id
  end
end
