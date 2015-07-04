class TalksLocationDate < ActiveRecord::Migration
  def change
    add_column :talks, :location, :string
    add_column :talks, :date, :datetime
  end
end
