class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.text :technical_description
      t.text :system_requirements
      t.string :source_url
      t.string :homepage
      t.boolean :approved
      t.float :final_score
      t.float :extra_score
      t.text :notes
      t.integer :user_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
