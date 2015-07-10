class TalksRemoveUserId < ActiveRecord::Migration
  def change
    remove_column :talks, :user_id
  end
end
