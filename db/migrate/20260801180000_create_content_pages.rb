class CreateContentPages < ActiveRecord::Migration[8.1]
  def change
    create_table :content_pages do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :title_en
      t.text :body, null: false
      t.text :body_en
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :content_pages, :slug, unique: true
    add_index :content_pages, [:active, :slug]
  end
end
