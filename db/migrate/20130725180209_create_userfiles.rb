class CreateUserfiles < ActiveRecord::Migration
  def change
    create_table :userfiles do |t|
      t.string :upload

      t.timestamps
    end
  end
end
