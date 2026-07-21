class AlumniUniqueUser < ActiveRecord::Migration[4.2]
  def change
    add_index :alumni, :user_id, :unique => true
  end
end
