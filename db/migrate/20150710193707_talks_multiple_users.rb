class TalksMultipleUsers < ActiveRecord::Migration
  def change
    create_table :talk_users do |t|
      t.integer :talk_id
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :talk_users, :talk_id
    add_index :talk_users, :user_id
  end
end
