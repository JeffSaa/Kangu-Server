class ChangeOrderProductsColumns < ActiveRecord::Migration[5.0]

  def change
  	remove_column :order_products, :provider_id
  	add_column :order_products, :user_id, :integer
  end

end
