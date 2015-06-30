class AccompanyingTecherName < ActiveRecord::Migration
  def change
    add_column :contestants, :accompanying_teacher_first_name, :string
    add_column :contestants, :accompanying_teacher_last_name, :string
    remove_column :contestants, :accompanying_teacher_id, :integer
  end
end
