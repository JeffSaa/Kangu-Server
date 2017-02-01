class AddCanCreateBusinessToUserType < ActiveRecord::Migration[5.0]

  def change
  	add_column :user_types, :can_create_business_place, :boolean, :default => false
  end

end
