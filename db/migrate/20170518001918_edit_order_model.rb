class EditOrderModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :orders, :user_id, :integer
  	remove_column :orders, :frepiman_id, :integer
  	remove_column :orders, :shopper_id, :integer
  	remove_column :orders, :interest, :float
  	remove_column :orders, :interest_date_max, :date
  	remove_column :orders, :interest_delay_days, :integer
  	remove_column :orders, :date, :date
  	remove_column :orders, :hour, :time
  	add_column :orders, :datehour, :datetime
  	add_column :orders, :target_id, :integer
  end

end
