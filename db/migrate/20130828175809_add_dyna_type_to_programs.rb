class AddDynaTypeToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :dyna_type, :string
  end
end
