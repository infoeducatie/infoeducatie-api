class CreateScreenshots < ActiveRecord::Migration[4.2]
  def change
    create_table :screenshots do |t|
      t.string :screenshot
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
