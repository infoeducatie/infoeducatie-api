class AddCurrentFieldToEditions < ActiveRecord::Migration
  def change
    add_column :editions, :is_current, :boolean, default: false
  end
end
