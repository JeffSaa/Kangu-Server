class CreateProductGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :product_groups do |t|
      t.string :name
      t.integer :type, :default => 0

      t.timestamps
    end
  end
end
