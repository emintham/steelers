class AddSpecialisationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :specialisation, :string
  end
end
