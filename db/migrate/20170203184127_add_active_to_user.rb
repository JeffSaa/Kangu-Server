class AddActiveToUser < ActiveRecord::Migration[5.0]
	
  def change
  	add_column :users, :active, :boolean, :default => false
  	add_column :users, :name, :string
  	add_column :users, :lastname, :string
  end

end
