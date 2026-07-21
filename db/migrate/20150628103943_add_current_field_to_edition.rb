class AddCurrentFieldToEdition < ActiveRecord::Migration[4.2]
  def change
    add_column :editions, :current, :boolean, default: false
  end
end
