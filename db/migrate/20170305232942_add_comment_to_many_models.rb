class AddCommentToManyModels < ActiveRecord::Migration[5.0]

  def change
  	add_column :business_products, :comment, :string
  	add_column :orders, :comment, :string
  end

end
