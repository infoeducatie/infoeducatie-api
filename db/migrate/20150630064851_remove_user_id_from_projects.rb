class RemoveUserIdFromProjects < ActiveRecord::Migration[4.2]
  def change
    remove_column :projects, :user_id, :integer
  end
end
