class CreateConfigParams < ActiveRecord::Migration
  def change
    create_table :config_params do |t|
      t.string :name
      t.string :param_type
      t.boolean :required
      t.belongs_to :config_template

      t.timestamps
    end
    add_index :config_params, :config_template_id
  end
end
