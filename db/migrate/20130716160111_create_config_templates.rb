class CreateConfigTemplates < ActiveRecord::Migration
  def change
    create_table :config_templates do |t|
      t.string :name

      t.timestamps
    end
  end
end
