class CreateConfs < ActiveRecord::Migration
  def change
    create_table :confs do |t|
      t.string :name
      t.belongs_to :program

      t.timestamps
    end
    add_index :confs, :program_id
  end
end
