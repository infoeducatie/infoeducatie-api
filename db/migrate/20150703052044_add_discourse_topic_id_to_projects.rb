class AddDiscourseTopicIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :discourse_topic_id, :integer
  end
end
