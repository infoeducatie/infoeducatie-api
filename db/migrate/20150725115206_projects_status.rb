class ProjectsStatus < ActiveRecord::Migration[4.2]
  def change
    remove_column :projects, :approved
    add_column :projects, :status, :integer
  end
end
