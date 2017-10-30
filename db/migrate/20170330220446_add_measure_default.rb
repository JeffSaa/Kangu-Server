class AddMeasureDefault < ActiveRecord::Migration[5.0]

  def change
  	add_column :products, :default_quantity, :float 
  end

end
