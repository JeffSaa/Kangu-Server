class AddDefaultValuesProductvariantsModel < ActiveRecord::Migration[5.0]

  def change
  	change_column_default :product_variants, :coin_price, 0
  	change_column_default :product_variants, :discount, 0
  end

end
