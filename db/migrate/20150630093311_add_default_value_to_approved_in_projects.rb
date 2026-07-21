class AddDefaultValueToApprovedInProjects < ActiveRecord::Migration[4.2]
  def change
    change_column :projects, :approved, :boolean, :default => false
  end
end
