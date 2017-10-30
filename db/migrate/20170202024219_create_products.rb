class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :group_id, :default => 0
      t.float :entry_price, :default => 0
      t.float :natural_price, :default => 0
      t.float :business_price, :default => 0
      t.integer :subcategorie_id, :default => 0
      t.boolean :enabled, :default => true
      t.integer :coin_price, :default => 0
      t.float :discount, :default => 0
      t.integer :provider_may_id, :default => 0
      t.integer :provider_min_id, :default => 0
      t.integer :type_size, :default => 0
      t.integer :cant_min_may, :default => 0
      t.integer :product_count, :default => 0

      t.timestamps
    end
  end
end
