class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :user_id, :default => 0
      t.integer :status, :default => 0
      t.integer :order_type, :default => 0
      t.boolean :isLate, :default => false
      t.integer :frepiman_id, :default => 0
      t.integer :shopper_id, :default => 0
      t.float :calification, :default => 0
      t.date :date
      t.time :hour
      t.float :paid, :default => 0
      t.float :due, :default => 0
      t.float :interest, :default => 0
      t.date :interest_date_max
      t.integer :interest_delay_days, :default => 0
      t.integer :pay_mode, :default => 0

      t.timestamps
    end
  end
end
