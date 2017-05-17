class CreateProductVariants < ActiveRecord::Migration[5.0]
  def change
    create_table :product_variants do |t|
      t.string :name
      t.float :entry_price
      t.float :natural_price
      t.float :business_price
      t.integer :coin_price
      t.float :discount
      t.integer :subcategorie_id
      t.integer :measurement_type
      t.integer :measurement_variant
      t.float :unit_quantity
      t.float :default_quantity

      t.timestamps
    end
  end
end
