class AddDefaultValueToApprovedInProjects < ActiveRecord::Migration
  def change
    change_column :projects, :approved, :boolean, :default => false
  end
end
