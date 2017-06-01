class EditUnitquantityFromVariant < ActiveRecord::Migration[5.0]

  def change
  	remove_column :product_variants, :unit_quantity, :integer
  	add_column :product_variants, :unit_measurement, :integer
  end

end
