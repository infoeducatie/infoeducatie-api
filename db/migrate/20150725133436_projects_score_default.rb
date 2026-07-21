class ProjectsScoreDefault < ActiveRecord::Migration[4.2]
  def change
    change_column :projects, :score, :float, {:null => false, :default => 0}
    change_column :projects, :extra_score, :float, {:null => false, :default => 0}
    change_column :projects, :total_score, :float, {:null => false, :default => 0}
  end
end
