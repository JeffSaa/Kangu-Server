class AddUnitToProduct < ActiveRecord::Migration[5.0]

  def change
  	remove_column :products, :measure_description
  	add_column :products, :unit_size, :float
  end

end
