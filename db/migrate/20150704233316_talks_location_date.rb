class TalksLocationDate < ActiveRecord::Migration[4.2]
  def change
    add_column :talks, :location, :string
    add_column :talks, :date, :datetime
  end
end
