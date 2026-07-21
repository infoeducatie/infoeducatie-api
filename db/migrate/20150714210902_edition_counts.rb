class EditionCounts < ActiveRecord::Migration[4.2]
  def change
    add_column :editions, :talks_count, :integer
  end
end
