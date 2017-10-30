class CreateUserTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_types do |t|
      t.string :name
      t.integer :business_id, :default => 0
      t.boolean :can_login_app_business, :default => false

      t.timestamps
    end
  end
end
