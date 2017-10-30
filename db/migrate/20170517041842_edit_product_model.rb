class EditProductModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :products, :group_id
  	remove_column :products, :entry_price
  	remove_column :products, :natural_price
  	remove_column :products, :business_price
  	remove_column :products, :subcategorie_id
  	remove_column :products, :coin_price
  	remove_column :products, :discount
  	remove_column :products, :provider_may_id
  	remove_column :products, :provider_min_id
  	remove_column :products, :type_size
  	remove_column :products, :cant_min_may
  	remove_column :products, :product_count
  	remove_column :products, :type_measure
  	remove_column :products, :unit_size
  	remove_column :products, :default_quantity
  end

end
