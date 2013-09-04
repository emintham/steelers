class AddNumProcsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :num_procs, :integer
  end
end
