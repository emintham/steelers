class ConfigParam < ActiveRecord::Base
  belongs_to :config_template
  attr_accessible :name, :param_type, :required
end
