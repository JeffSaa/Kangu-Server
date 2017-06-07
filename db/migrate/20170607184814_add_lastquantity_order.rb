class AddLastquantityOrder < ActiveRecord::Migration[5.0]

  def change
  	add_column :order_products, :last_quantity, :float, :default => 0
  end

end
