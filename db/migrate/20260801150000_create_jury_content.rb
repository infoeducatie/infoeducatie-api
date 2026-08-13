class CreateJuryContent < ActiveRecord::Migration[8.1]
  def change
    create_table :jury_categories do |t|
      t.string :title, null: false
      t.string :title_en, null: false
      t.string :icon
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :jury_categories, :title, unique: true
    add_index :jury_categories, :position

    create_table :jury_members do |t|
      t.string :title
      t.string :title_en
      t.string :name, null: false
      t.string :photo, null: false
      t.string :occupation, null: false
      t.string :occupation_en
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.references :jury_category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :jury_members, [:jury_category_id, :position]
  end
end
