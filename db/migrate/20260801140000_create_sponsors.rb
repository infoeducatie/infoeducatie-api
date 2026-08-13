class CreateSponsors < ActiveRecord::Migration[8.1]
  def change
    create_table :sponsor_tiers do |t|
      t.string :name, null: false
      t.string :name_en
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :sponsor_tiers, :name, unique: true
    add_index :sponsor_tiers, :position

    create_table :sponsors do |t|
      t.string :title, null: false
      t.string :image, null: false
      t.string :website_url
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true
      t.references :sponsor_tier, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sponsors, [:sponsor_tier_id, :position]
  end
end
