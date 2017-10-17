class AddWcToOrders < ActiveRecord::Migration[5.0]

  def change
  	add_column :orders, :wc_name, :string
  	add_column :orders, :wc_lastname, :string
  	add_column :orders, :wc_address, :string
  	add_column :orders, :wc_phone, :integer, limit: 8, :default => 0
  end

end