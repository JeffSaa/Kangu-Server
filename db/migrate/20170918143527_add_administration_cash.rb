class AddAdministrationCash < ActiveRecord::Migration[5.0]

  def change
  	add_column :wallets, :cash_id, :integer
  	add_column :wallets, :cash_balance, :float, :default => 0
  end

end
