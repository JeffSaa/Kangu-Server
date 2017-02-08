class CreateOrderProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :order_products do |t|
      t.integer :order_id, :default => 0
      t.integer :product_id, :default => 0
      t.float :price, :default => 0
      t.integer :provider_id, :default => 0 # Asignar a un usuario
      										# Asignarlo a una lista

      t.timestamps
    end
  end
end
