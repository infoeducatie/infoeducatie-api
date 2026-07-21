class NewsAddShortField < ActiveRecord::Migration[4.2]
  def change
    add_column :news, :short, :text
  end
end
