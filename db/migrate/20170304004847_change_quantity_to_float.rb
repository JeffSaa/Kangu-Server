class ChangeQuantityToFloat < ActiveRecord::Migration[5.0]

  def change
  	change_column :business_products, :quantity, :float
  	change_column :order_products, :quantity, :float
  end

end
