class ProjectsScoreNote < ActiveRecord::Migration
  def change
    remove_column :projects, :final_score
    remove_column :projects, :notes
    add_column :projects, :score, :float
    add_column :projects, :total_score, :float
    add_column :projects, :prize, :string
  end
end
