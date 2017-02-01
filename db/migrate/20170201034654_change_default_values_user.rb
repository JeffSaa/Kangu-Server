class ChangeDefaultValuesUser < ActiveRecord::Migration[5.0]

  def change
  	change_column :users, :have_custom_products, :boolean, :default => false
  	change_column :users, :frepi_coins, :integer, :default => 0
  	change_column :users, :business_id, :integer, :default => 0
  	change_column :users, :quota_max, :integer, :default => 0
  	change_column :users, :current_quota, :integer, :default => 0
  	remove_column :users, :user_group
  	add_column :users, :user_group_id, :integer, :default => 0
  end

end
