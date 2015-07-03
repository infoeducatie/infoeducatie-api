class AddRegistrationStepNumberToUser < ActiveRecord::Migration
  def change
    add_column :users, :registration_step_number, :integer, default: 1
  end
end
