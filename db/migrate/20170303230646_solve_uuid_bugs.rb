class SolveUuidBugs < ActiveRecord::Migration[5.0]

  def change
  	remove_column :users, :uuid, :uuid
  	remove_column :products, :uid, :uuid
  	add_column :users, :uuid, :uuid, default: 'uuid_generate_v4()'
  	add_column :products, :uuid, :uuid, default: 'uuid_generate_v4()'
  end

end
