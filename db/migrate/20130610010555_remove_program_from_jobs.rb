class RemoveProgramFromJobs < ActiveRecord::Migration
  def up
    remove_column :jobs, :program
  end

  def down
    add_column :jobs, :program, :string
  end
end
