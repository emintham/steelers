class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.integer :job_id
      t.string :input
      t.string :output
      t.string :user_id

      t.timestamps
    end
  end
end
