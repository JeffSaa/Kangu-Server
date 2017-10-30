class EditProductvariant < ActiveRecord::Migration[5.0]

  def change
  	add_column :product_variants, :product_id, :integer
  end

end
