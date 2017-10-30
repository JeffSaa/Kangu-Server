class UserTypeUpdate < ActiveRecord::Migration[5.0]

  def change
  	remove_column :users, :type_id
  	remove_column :users, :have_custom_products
  	remove_column :users, :quota_max
  	remove_column :users, :current_quota
  	remove_column :users, :user_group_id
  	remove_column :users, :sucursal_id
  	remove_column :business_places, :user_id
  	add_column :business_sucursals, :coins, :integer, :default => 0
  end

end
