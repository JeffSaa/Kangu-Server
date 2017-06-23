class AddIvaToProducts < ActiveRecord::Migration[5.0]

  def change
  	add_column :product_variants, :iva, :float
  	add_column :order_products, :iva, :float
  end

end
