class CommentsDefault < ActiveRecord::Migration
  def change
    change_column :projects, :comments_count, :integer, {:null => false, :default => 0}
    change_column :talks, :comments_count, :integer, {:null => false, :default => 0}
  end
end
