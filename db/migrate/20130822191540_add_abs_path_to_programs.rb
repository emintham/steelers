class AddAbsPathToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :abs_path, :string
  end
end
