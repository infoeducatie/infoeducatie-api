class ProjectAddClosedSourceReason < ActiveRecord::Migration
  def change
    add_column :projects, :closed_source_reason, :string
  end
end
