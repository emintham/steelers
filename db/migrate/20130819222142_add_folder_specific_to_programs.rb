class AddFolderSpecificToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :folder_specific, :boolean
  end
end
