class EditionForumCategory < ActiveRecord::Migration
  def change
    add_column :editions, :projects_forum_category, :string
  end
end
