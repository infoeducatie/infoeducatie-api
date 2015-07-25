class TalksForumCategory < ActiveRecord::Migration
  def change
    add_column :editions, :talks_forum_category, :string
  end
end
