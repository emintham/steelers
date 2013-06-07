class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :server
      t.string :input
      t.string :description
      t.string :owner
      t.boolean :status
      t.string :output

      t.timestamps
    end
  end
end
