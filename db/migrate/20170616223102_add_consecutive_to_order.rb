class AddConsecutiveToOrder < ActiveRecord::Migration[5.0]

  def change
  	add_column :orders, :consecutive, :integer
  end

end
