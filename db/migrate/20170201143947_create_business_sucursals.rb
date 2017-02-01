class CreateBusinessSucursals < ActiveRecord::Migration[5.0]
  def change
    create_table :business_sucursals do |t|
      t.integer :business_id

      t.timestamps
    end
  end
end
