class AddSucursalToUser < ActiveRecord::Migration[5.0]

  def change
  	add_column :users, :sucursal_id, :integer, :default => 0
  end

end
