class ChangeBusinessProductModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :business_products, :product_id
  	add_column :business_products, :product_id, :integer
  	add_column :business_products, :type_measure, :integer
  end

end
