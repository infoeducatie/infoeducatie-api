class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.text :technologies
      t.string :coordinators
      t.string :url
      t.boolean :is_approved
      t.integer :edition_id

      t.timestamps
    end
  end
end
