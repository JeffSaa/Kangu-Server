class CreateBusinesses < ActiveRecord::Migration[5.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :domain
      t.integer :user_id

      t.timestamps
    end
  end
end
