class CreateScreenshots < ActiveRecord::Migration
  def change
    create_table :screenshots do |t|
      t.string :screenshot
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
