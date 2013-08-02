class AddUserIdToUserfiles < ActiveRecord::Migration
  def change
    add_column :userfiles, :user_id, :integer
  end
end
