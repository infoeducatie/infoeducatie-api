class AddCurrentFieldToEdition < ActiveRecord::Migration
  def change
    add_column :editions, :current, :boolean, default: false
  end
end
