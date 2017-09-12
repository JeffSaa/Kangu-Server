class CreateInventoryEntries < ActiveRecord::Migration[5.0]
	def change
		create_table :inventory_entries do |t|
			t.integer :variant_id
			t.float :quantity
			t.float :unit_value
			t.integer :group_id

			t.timestamps
		end
	end
end
