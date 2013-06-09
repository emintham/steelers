class AddProgramToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :program, :string
  end
end
