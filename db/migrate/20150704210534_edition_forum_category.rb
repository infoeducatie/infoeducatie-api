class EditionForumCategory < ActiveRecord::Migration[4.2]
  def change
    add_column :editions, :projects_forum_category, :string
  end
end
