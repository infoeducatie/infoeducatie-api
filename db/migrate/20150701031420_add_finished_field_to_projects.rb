class AddFinishedFieldToProjects < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :finished, :boolean, default: false
  end
end
