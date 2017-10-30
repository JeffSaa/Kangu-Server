class ChangeProductsPriceModel < ActiveRecord::Migration[5.0]

  def change
  	add_column :products, :type_measure, :integer
  end

end
