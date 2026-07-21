class ProjectAddClosedSourceReason < ActiveRecord::Migration[4.2]
  def change
    add_column :projects, :closed_source_reason, :string
  end
end
