class AddDescriptionToConfigParams < ActiveRecord::Migration
  def change
    add_column :config_params, :description, :text
  end
end
