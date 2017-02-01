class AddSucursalCreationPermission < ActiveRecord::Migration[5.0]
	
  def change
  	add_column :user_types, :can_create_business_sucursal, :boolean, :default => false
  end
  
end
