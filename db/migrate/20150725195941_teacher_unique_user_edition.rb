class TeacherUniqueUserEdition < ActiveRecord::Migration[4.2]
  def change
    add_index :teachers, ["user_id", "edition_id"], :unique => true
  end
end
