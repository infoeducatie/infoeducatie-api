class EditionRmIsCurrentField < ActiveRecord::Migration[4.2]
  def change
   remove_column :editions, :is_current
  end
end
