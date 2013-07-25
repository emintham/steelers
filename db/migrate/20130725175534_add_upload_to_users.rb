class AddUploadToUsers < ActiveRecord::Migration
  def change
    add_column :users, :upload, :string
  end
end
