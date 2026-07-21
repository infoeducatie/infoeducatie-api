class AddEditionToTalks < ActiveRecord::Migration[4.2]
  def change
    add_column :talks, :edition_id, :integer
  end
end
