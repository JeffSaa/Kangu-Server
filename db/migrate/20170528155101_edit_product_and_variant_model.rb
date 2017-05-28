class EditProductAndVariantModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :product_variants, :measurement_type, :integer
  	remove_column :product_variants, :measurement_variant, :integer
  	remove_column :product_variants, :subcategorie_id, :integer
  	add_column :products, :measurement_type, :integer
  	add_column :products, :measurement_variant, :integer
  	add_column :products, :subcategorie_id, :integer
  end

end
