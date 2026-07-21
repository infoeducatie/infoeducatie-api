class TalksRemoveUserId < ActiveRecord::Migration[4.2]
  def change
    remove_column :talks, :user_id
  end
end
