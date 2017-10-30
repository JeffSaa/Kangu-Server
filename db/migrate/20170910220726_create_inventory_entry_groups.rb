class CreateInventoryEntryGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_entry_groups do |t|
    	t.date :date
  		t.string :bill_number
  		t.integer :provider_id
  		t.date :pay_day
  		t.boolean :is_payed, :default => false

      t.timestamps
    end
  end
end
