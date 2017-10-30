class FixPhoneUserModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :users, :phone, :integer
  	add_column :users, :phone, :integer, limit: 8, :default => 0
  end

end
