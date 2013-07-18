class AddProgramIdToConfigTemplates < ActiveRecord::Migration
  def change
    add_column :config_templates, :program_id, :integer
  end
end
