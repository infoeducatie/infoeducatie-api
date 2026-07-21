class ProjectAddOpenSourceField < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :open_source, :boolean
  end
end
