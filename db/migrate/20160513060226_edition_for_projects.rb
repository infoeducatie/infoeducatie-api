class EditionForProjects < ActiveRecord::Migration
  def change
    add_column :projects, :edition_id, :integer
    add_index :projects, :edition_id
    change_column_null :projects, :edition_id, false
  end
end
