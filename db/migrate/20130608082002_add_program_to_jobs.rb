class AddProgramToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :program, :string
  end
end
