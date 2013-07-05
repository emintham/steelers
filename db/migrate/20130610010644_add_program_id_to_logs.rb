class AddProgramIdToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :program_id, :integer
  end
end
