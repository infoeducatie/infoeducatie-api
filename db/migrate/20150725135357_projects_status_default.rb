class ProjectsStatusDefault < ActiveRecord::Migration
  def change
    change_column :projects, :status, :integer, {:null => false, :default => 0}
  end
end
