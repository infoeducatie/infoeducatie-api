class TalksRemoveLocationDate < ActiveRecord::Migration
  def change
    remove_column :talks, :location
    remove_column :talks, :date
  end
end
