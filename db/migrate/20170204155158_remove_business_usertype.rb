class RemoveBusinessUsertype < ActiveRecord::Migration[5.0]

  def change
  	remove_column :user_types, :business_id
  end

end
