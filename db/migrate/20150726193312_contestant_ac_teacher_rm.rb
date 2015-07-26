class ContestantAcTeacherRm < ActiveRecord::Migration
  def change
    remove_column :contestants, :accompanying_teacher_first_name
    remove_column :contestants, :accompanying_teacher_last_name
  end
end
