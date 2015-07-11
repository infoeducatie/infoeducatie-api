class TalksAddTopic < ActiveRecord::Migration
  def change
    add_column :talks, :topic_id, :integer
  end
end
