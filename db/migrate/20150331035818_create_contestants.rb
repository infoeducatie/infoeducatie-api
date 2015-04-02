class CreateContestants < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
      t.string :address
      t.string :city
      t.string :county
      t.string :country
      t.string :zip_code
      t.string :cnp
      t.integer :sex # this is int because we create an enum on the rails side of things
      t.string :id_card_type
      t.string :id_card_number
      t.string :phone_number
      t.string :school_name
      t.string :grade
      t.string :school_county
      t.string :school_city
      t.string :school_country
      t.date :date_of_birth
      t.string :mentoring_teacher_first_name
      t.string :mentoring_teacher_last_name
      t.boolean :official
      t.integer :user_id
      t.integer :edition_id
      t.integer :accompanying_teacher_id

      t.timestamps null: false
    end
  end
end
