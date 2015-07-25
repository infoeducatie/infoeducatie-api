class AlumniUniqueUser < ActiveRecord::Migration
  def change
    add_index :alumni, :user_id, :unique => true
  end
end
