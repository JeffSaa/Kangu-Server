class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens, id: :uuid  do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
