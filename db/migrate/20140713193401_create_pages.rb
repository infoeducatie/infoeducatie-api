class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.text :body
      t.integer :edited_by
      t.integer :version
      t.integer :edition_id

      t.timestamps
    end
  end
end
