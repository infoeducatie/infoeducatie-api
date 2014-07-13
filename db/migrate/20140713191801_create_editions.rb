class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.datetime :start
      t.datetime :end
      t.integer :cardinal
      t.string :motto

      t.timestamps
    end
    add_index :editions, :cardinal, unique: true
  end
end
