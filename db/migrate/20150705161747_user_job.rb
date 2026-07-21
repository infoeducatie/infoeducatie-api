class UserJob < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :job, :string
  end
end
