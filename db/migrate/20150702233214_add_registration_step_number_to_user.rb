class AddRegistrationStepNumberToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :registration_step_number, :integer, default: 1
  end
end
