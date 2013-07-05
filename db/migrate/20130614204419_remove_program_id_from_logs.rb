class RemoveProgramIdFromLogs < ActiveRecord::Migration
  def up
    remove_column :logs, :program_id
  end

  def down
    add_column :logs, :program_id, :string
  end
end
