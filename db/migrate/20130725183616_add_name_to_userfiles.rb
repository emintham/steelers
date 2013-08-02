class AddNameToUserfiles < ActiveRecord::Migration
  def change
    add_column :userfiles, :name, :string
  end
end
