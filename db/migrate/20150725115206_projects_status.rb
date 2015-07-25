class ProjectsStatus < ActiveRecord::Migration
  def change
    remove_column :projects, :approved
    add_column :projects, :status, :integer
  end
end
