class CommentsDefault < ActiveRecord::Migration[4.2]
  def change
    change_column :projects, :comments_count, :integer, {:null => false, :default => 0}
    change_column :talks, :comments_count, :integer, {:null => false, :default => 0}
  end
end
