class AddUidToProductUser < ActiveRecord::Migration[5.0]

  def change
  	add_column :users, :uuid, :uuid
  	add_column :products, :uid, :uuid
  end

end
