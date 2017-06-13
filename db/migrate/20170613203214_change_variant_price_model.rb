class ChangeVariantPriceModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :product_variants, :natural_price, :float
  	remove_column :product_variants, :business_price, :float
  	add_column :product_variants, :business_percent, :float
  	add_column :product_variants, :business_gain, :float
  	add_column :product_variants, :natural_percent, :float
  	add_column :product_variants, :natural_gain, :float
  end

end
