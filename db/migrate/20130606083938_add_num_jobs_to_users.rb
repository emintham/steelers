class AddNumJobsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :num_jobs, :integer
  end
end
