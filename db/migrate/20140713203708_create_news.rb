class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :description
      t.integer :edition_id
      t.boolean :is_pinned

      t.timestamps
    end
  end
end
