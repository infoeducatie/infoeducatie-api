class CreateJudgingCriteria < ActiveRecord::Migration[8.1]
  def change
    create_table :judging_criteria do |t|
      t.string :title, null: false
      t.string :title_en, null: false
      t.string :document, null: false
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :judging_criteria, :title, unique: true
    add_index :judging_criteria, :position
    add_index :judging_criteria, [:active, :position]
  end
end
