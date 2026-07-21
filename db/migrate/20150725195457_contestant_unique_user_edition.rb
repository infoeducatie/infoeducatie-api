class ContestantUniqueUserEdition < ActiveRecord::Migration[4.2]
  def change
    add_index :contestants, ["user_id", "edition_id"], :unique => true
  end
end
