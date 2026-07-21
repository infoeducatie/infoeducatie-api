class TalksRemoveLocationDate < ActiveRecord::Migration[4.2]
  def change
    remove_column :talks, :location
    remove_column :talks, :date
  end
end
