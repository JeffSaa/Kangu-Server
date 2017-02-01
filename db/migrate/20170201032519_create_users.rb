class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.integer :type_id
      t.string :email
      t.string :password
      t.string :address_description
      t.float :address_latitude
      t.float :address_longitude
      t.boolean :have_custom_products
      t.integer :frepi_coins
      t.integer :business_id
      t.float :quota_max
      t.float :current_quota
      t.string :user_group

      t.timestamps
    end
  end
end
