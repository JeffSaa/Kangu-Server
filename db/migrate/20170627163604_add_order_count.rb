class AddOrderCount < ActiveRecord::Migration[5.0]

  def change
  	add_column :users, :order_count, :integer, :default => 0
  	add_column :business_sucursals, :order_count, :integer, :default => 0
  end

end
