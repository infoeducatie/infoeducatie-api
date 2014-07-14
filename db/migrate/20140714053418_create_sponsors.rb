class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.integer :edition_id
      t.string :name
      t.string :logo

      t.timestamps
    end
  end
end
