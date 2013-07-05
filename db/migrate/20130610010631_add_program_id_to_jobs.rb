class AddProgramIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :program_id, :integer
  end
end
