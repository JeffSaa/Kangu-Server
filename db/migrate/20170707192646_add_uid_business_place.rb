class AddUidBusinessPlace < ActiveRecord::Migration[5.0]

  def change
  	add_column :business_places, :uid, :uuid, default: 'uuid_generate_v4()'
  	add_column :business_sucursals, :uid, :uuid, default: 'uuid_generate_v4()'
  end

end
