class AddUuidProductvariant < ActiveRecord::Migration[5.0]

  def change
  	add_column :product_variants, :uuid, :uuid, default: 'uuid_generate_v4()'
  end

end
