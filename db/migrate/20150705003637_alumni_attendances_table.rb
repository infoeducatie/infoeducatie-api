class AlumniAttendancesTable < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :alumnus_id
      t.integer :edition_id

      t.timestamps null: false
    end
  end
end
