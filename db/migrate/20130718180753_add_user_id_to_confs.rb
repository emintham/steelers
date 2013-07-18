class AddUserIdToConfs < ActiveRecord::Migration
  def change
    add_column :confs, :user_id, :integer
  end
end
