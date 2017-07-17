class CreateInventoryEntries < ActiveRecord::Migration[5.0]
	def change
		create_table :inventory_entries do |t|
			t.date :date
			t.string :bill_number
			t.integer :provider_id
			t.integer :variant_id
			t.float :quantity
			t.float :unit_value
			t.boolean :is_payed
			t.date :pay_day

			t.timestamps
		end
	end
end
