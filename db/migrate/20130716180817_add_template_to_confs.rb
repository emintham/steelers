class AddTemplateToConfs < ActiveRecord::Migration
  def change
    add_column :confs, :config_template_id, :integer
    add_column :confs, :properties, :text
  end
end
