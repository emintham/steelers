class RemoveUserIdFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :user_id
  end

  def down
    add_column :jobs, :user_id, :string
  end
end
