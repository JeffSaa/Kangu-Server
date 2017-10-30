class AddBusinesspriceNaturalprice < ActiveRecord::Migration[5.0]

  def change
  	add_column :product_variants, :natural_price, :float
  	add_column :product_variants, :business_price, :float
  end

end
