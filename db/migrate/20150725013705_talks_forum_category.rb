class TalksForumCategory < ActiveRecord::Migration[4.2]
  def change
    add_column :editions, :talks_forum_category, :string
  end
end
