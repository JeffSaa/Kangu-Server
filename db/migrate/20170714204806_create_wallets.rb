class CreateWallets < ActiveRecord::Migration[5.0]
	def change
		create_table :wallets do |t|
			t.date :date
			t.float :total
			t.integer :mov_type
			t.integer :source_type
			t.integer :third_type
			t.integer :third_id
			t.float :balance

			t.timestamps
		end
	end
end
