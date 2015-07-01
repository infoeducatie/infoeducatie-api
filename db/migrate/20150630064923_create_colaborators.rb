class CreateColaborators < ActiveRecord::Migration
  def change
    create_table :colaborators do |t|
      t.integer :contestant_id
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
