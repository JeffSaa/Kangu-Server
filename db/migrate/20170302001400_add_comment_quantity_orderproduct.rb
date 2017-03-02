class AddCommentQuantityOrderproduct < ActiveRecord::Migration[5.0]

  def change
  	add_column :order_products, :comment, :string
  	add_column :order_products, :quantity, :integer
  	add_column :order_products, :measure_type, :integer
  end

end
