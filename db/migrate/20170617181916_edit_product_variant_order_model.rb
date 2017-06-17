class EditProductVariantOrderModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :products, :enabled, :boolean
  	add_column :products, :enabled, :integer, :default => 0
  	add_column :product_variants, :enabled, :integer, :default => 0
  	remove_column :orders, :paid, :float
  	remove_column :orders, :due, :float
  	add_column :orders, :total, :float, :default => 0
  end

end
