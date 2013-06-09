class AddServerIdToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :server_id, :integer
  end
end
