class EditionShowResults < ActiveRecord::Migration[4.2]
  def change
    add_column :editions, :show_results, :boolean
  end
end
