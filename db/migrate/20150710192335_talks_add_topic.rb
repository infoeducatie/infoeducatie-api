class TalksAddTopic < ActiveRecord::Migration[4.2]
  def change
    add_column :talks, :topic_id, :integer
  end
end
