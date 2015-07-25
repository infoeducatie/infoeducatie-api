class TeacherUniqueUserEdition < ActiveRecord::Migration
  def change
    add_index :teachers, ["user_id", "edition_id"], :unique => true
  end
end
