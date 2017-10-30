class ChangeUnitToFloatVariantModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :product_variants, :unit_measurement, :integer
  	add_column :product_variants, :unit_measurement, :float, :default => 0
  end

end
