class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name
      t.string :ip
      t.integer :num_jobs

      t.timestamps
    end
  end
end
