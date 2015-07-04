class ConnectNewsEdition < ActiveRecord::Migration
  def change
    add_column :news, :edition_id, :integer
  end
end
