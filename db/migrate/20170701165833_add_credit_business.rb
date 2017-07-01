class AddCreditBusiness < ActiveRecord::Migration[5.0]

  def change
  	add_column :business_places, :credit_term, :integer, :default => 0
  	add_column :business_places, :credit_fit, :float, :default => 0
  	add_column :business_places, :current_deb, :float, :default => 0
  	add_column :business_places, :credit_active, :boolean, :default => false
  	add_column :orders, :credit_interest, :float, :default => 0
  	add_column :orders, :pay_day, :date
  	add_column :orders, :next_interest_day, :date
	add_column :orders, :interest_count, :integer, :default => 0
  end

end
