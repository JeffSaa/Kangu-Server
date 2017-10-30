class ChangeVariantModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :product_variants, :coin_price, :integer
  	add_column :product_variants, :original_image, :string
  end

end
