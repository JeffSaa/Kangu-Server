class AddAdministrarionFields < ActiveRecord::Migration[5.0]

  def change
  	add_column :business_places, :nit, :string
  	add_column :users, :cc, :integer, limit: 8
  	add_column :order_products, :discount, :float, :default => 0 
  end

end
