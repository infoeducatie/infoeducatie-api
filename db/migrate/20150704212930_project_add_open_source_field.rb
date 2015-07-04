class ProjectAddOpenSourceField < ActiveRecord::Migration
  def change
    add_column :projects, :open_source, :boolean
  end
end
