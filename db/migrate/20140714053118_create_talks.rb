class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.string :title
      t.text :description
      t.datetime :scheduled_at
      t.integer :duration
      t.string :location

      t.timestamps
    end
  end
end
