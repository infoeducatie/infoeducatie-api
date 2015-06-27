class CreateRights < ActiveRecord::Migration
  def change
    create_table :rights do |t|
      t.integer :user_id
      t.integer :role_id
      t.timestamps null: false
    end

    add_index :rights, :user_id
    add_index :rights, :role_id
  end
end
