class DeleteBusinessIdFromUser < ActiveRecord::Migration[5.0]

  def change
  	remove_column :users, :business_id, :integer
  end

end
