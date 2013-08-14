class CreateUserfiles < ActiveRecord::Migration
  def change
    create_table :userfiles do |t|
      t.references :user
      t.string :name

      t.timestamps
    end
    add_index :userfiles, :user_id
  end
end
