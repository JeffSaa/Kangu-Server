class EditBusinessModel < ActiveRecord::Migration[5.0]

  def change
  	remove_column :business_places, :domain
  	add_column :users, :phone, :integer
  	add_column :business_sucursals, :phone, :integer
  	add_column :business_sucursals, :address_description, :string
  	add_column :business_sucursals, :address_latitude, :integer
  	add_column :business_sucursals, :address_longitude, :integer
  end

end
