class RemoveMeasureTypes < ActiveRecord::Migration[5.0]

  def change
  	remove_column :business_products, :type_measure
  	remove_column :order_products, :measure_type	
  end

end
