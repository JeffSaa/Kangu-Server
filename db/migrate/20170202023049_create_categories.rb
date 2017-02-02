class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :type, :default => 0
      t.integer :categorie_id, :default => 0

      t.timestamps
    end
  end
end
