class CreateCreditNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_notes do |t|
      t.integer :consecutive
      t.integer :order_id
      t.float :total

      t.timestamps
    end
  end
end
