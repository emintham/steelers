class RemoveOwnerFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :owner
  end

  def down
    add_column :jobs, :owner, :string
  end
end
