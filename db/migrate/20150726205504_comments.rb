class Comments < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :comments_count, :integer
    add_column :talks, :comments_count, :integer
  end
end
