class FixPhoneSucursal < ActiveRecord::Migration[5.0]

  def change
  	remove_column :business_sucursals, :phone, :integer
  	add_column :business_sucursals, :phone, :integer, limit: 8, :default => 0
  end

end
