class AddCurrentFieldToEditions < ActiveRecord::Migration[4.2]
  def change
    add_column :editions, :is_current, :boolean, default: false
  end
end
