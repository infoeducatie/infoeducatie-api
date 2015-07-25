class ContestantUniqueUserEdition < ActiveRecord::Migration
  def change
    add_index :contestants, ["user_id", "edition_id"], :unique => true
  end
end
