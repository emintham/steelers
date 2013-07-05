class RemoveProgramFromLogs < ActiveRecord::Migration
  def up
    remove_column :logs, :program
  end

  def down
    add_column :logs, :program, :string
  end
end
