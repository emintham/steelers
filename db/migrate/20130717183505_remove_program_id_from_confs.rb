class RemoveProgramIdFromConfs < ActiveRecord::Migration
  def up
    remove_column :confs, :program_id
  end

  def down
    add_column :confs, :program_id, :string
  end
end
