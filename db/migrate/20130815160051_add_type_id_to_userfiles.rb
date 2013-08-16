class AddTypeIdToUserfiles < ActiveRecord::Migration
  def change
    add_column :userfiles, :type_id, :integer
  end
end
