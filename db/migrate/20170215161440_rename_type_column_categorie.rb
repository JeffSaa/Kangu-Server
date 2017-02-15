class RenameTypeColumnCategorie < ActiveRecord::Migration[5.0]

  def change
  	rename_column :categories, :type, :categorie_type
  end

end
