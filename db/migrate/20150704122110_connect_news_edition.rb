class ConnectNewsEdition < ActiveRecord::Migration[4.2]
  def change
    add_column :news, :edition_id, :integer
  end
end
