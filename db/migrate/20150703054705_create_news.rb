class CreateNews < ActiveRecord::Migration[4.2]
  def change
    create_table :news do |t|
      t.string :title
      t.text :body
      t.boolean :pinned, default: false

      t.timestamps null: false
    end
  end
end
