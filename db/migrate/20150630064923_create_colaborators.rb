class CreateColaborators < ActiveRecord::Migration[4.2]
  def change
    create_table :colaborators do |t|
      t.integer :contestant_id
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
