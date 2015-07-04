class AddEditionToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :edition_id, :integer
  end
end
