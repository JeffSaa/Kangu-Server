class AddUidToOrders < ActiveRecord::Migration[5.0]

  def change
  	add_column :orders, :uid, :uuid, default: 'uuid_generate_v4()'
  end

end
