class CreateBusinessPlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :business_places do |t|
      t.string :name
      t.string :domain
      t.integer :user_id

      t.timestamps
    end
  end
end
