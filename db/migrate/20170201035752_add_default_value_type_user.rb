class AddDefaultValueTypeUser < ActiveRecord::Migration[5.0]
	
  def change
  	change_column :users, :type_id, :integer, :default => 0
  end
  
end
