class RoleNameUnique < ActiveRecord::Migration[4.2]
  def change
    add_index :roles, :name, unique: true
  end
end
