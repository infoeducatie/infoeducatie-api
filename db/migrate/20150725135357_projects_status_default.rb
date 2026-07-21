class ProjectsStatusDefault < ActiveRecord::Migration[4.2]
  def change
    change_column :projects, :status, :integer, {:null => false, :default => 0}
  end
end
