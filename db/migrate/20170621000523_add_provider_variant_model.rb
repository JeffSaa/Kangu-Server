class AddProviderVariantModel < ActiveRecord::Migration[5.0]

  def change
  	add_column :order_products, :provider_id, :integer
  end

end
