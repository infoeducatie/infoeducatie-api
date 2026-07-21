class AddDiscourseTopicIdToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :discourse_topic_id, :integer
  end
end
