class AddEditionToSeminars < ActiveRecord::Migration
  def change
    add_column :seminars, :edition_id, :integer
  end
end
