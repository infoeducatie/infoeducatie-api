class Teacher < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer  "sex"
      t.string   "phone_number"
      t.string   "school_name"
      t.string   "school_county"
      t.string   "school_city"
      t.string   "school_country"
      t.integer  "user_id"
      t.integer  "edition_id"

      t.timestamps null: false
    end

  end
end
