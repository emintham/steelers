class AddServerToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :server_id, :integer
  end
end
