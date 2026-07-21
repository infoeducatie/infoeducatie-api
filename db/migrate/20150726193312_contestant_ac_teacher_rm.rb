class ContestantAcTeacherRm < ActiveRecord::Migration[4.2]
  def change
    remove_column :contestants, :accompanying_teacher_first_name
    remove_column :contestants, :accompanying_teacher_last_name
  end
end
