class AddMeasureDescriptionToProductModel < ActiveRecord::Migration[5.0]

  def change
  	add_column :products, :measure_description, :string
  end

end