class RenameChargeModelField < ActiveRecord::Migration[5.0]

  def change
  	remove_column :charges, :type
  	add_column :charges, :type_id, :integer
  end

end
