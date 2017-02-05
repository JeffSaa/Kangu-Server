class CreateBusinessProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :business_products do |t|
      t.integer :user_id
      t.string :product_id
      t.integer :quantity

      t.timestamps
    end
  end
end
