class EditionShowResults < ActiveRecord::Migration
  def change
    add_column :editions, :show_results, :boolean
  end
end
