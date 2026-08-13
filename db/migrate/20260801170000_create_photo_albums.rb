class CreatePhotoAlbums < ActiveRecord::Migration[8.1]
  def change
    create_table :photo_albums do |t|
      t.string :title, null: false
      t.string :title_en
      t.string :external_url, null: false
      t.string :cover_image, null: false
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :photo_albums, [:active, :position]
    add_index :photo_albums, :title
  end
end
