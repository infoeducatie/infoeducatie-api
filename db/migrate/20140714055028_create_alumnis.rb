class CreateAlumnis < ActiveRecord::Migration
  def change
    create_table :alumnis do |t|
      t.string :description
      t.string :picture
      t.integer :user_id

      t.timestamps
    end
  end
end
