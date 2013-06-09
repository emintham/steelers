class RemoveServerFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :server
  end

  def down
    add_column :jobs, :server, :string
  end
end
