class RemoveServerIdFromLogs < ActiveRecord::Migration
  def up
    remove_column :logs, :server_id
  end

  def down
    add_column :logs, :server_id, :string
  end
end
