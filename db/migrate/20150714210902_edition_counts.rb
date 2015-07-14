class EditionCounts < ActiveRecord::Migration
  def change
    add_column :editions, :talks_count, :integer
  end
end
