class EditionRmIsCurrentField < ActiveRecord::Migration
  def change
   remove_column :editions, :is_current
  end
end
