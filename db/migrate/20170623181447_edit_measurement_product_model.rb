class EditMeasurementProductModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :products, :measurement_variant, :integer
  	add_column :product_variants, :description, :string
  end
  
end