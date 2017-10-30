class CreateCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
      t.integer :user_id
      t.integer :type
      t.integer :target_id

      t.timestamps
    end
  end
end
