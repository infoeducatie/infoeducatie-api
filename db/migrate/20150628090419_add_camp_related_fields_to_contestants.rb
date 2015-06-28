class AddCampRelatedFieldsToContestants < ActiveRecord::Migration
  def change
    add_column :contestants, :present_in_camp, :boolean, default: false
    add_column :contestants, :paying_camp_accommodation, :boolean, default: false
  end
end
