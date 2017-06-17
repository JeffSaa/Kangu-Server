class CreateCreditNoteItems < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_note_items do |t|
      t.integer :note_id
      t.integer :product_id
      t.float :quantity

      t.timestamps
    end
  end
end
