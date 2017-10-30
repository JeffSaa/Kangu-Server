class AddNameToSucursal < ActiveRecord::Migration[5.0]

  def change
  	add_column :business_sucursals, :name, :string
  end

end
