class AddProductStock < ActiveRecord::Migration[5.0]

  def change
  	add_column :inventory_entries, :variant_stock, :float, :default => 0
  	add_column :product_variants, :variant_stock, :float, :default => 0
  	add_column :inventory_entry_groups, :is_entry, :boolean, :default => true
  end

end
