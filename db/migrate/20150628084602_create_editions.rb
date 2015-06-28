class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.integer :year
      t.string :name
      t.date :camp_start_date
      t.date :camp_end_date
      t.string :motto
      t.datetime :registration_start_date
      t.datetime :registration_end_date
      t.date :travel_data_deadline
      t.boolean :published

      t.timestamps null: false
    end
  end
end
