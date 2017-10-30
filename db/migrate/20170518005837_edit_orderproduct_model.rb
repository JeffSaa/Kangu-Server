class EditOrderproductModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :order_products, :user_id, :integer
  	remove_column :order_products, :product_id, :integer
  	add_column :order_products, :variant_id, :integer
  end

end
