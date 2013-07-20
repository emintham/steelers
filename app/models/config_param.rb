class ConfigParam < ActiveRecord::Base
  belongs_to :config_template
  attr_accessible :name, :param_type, :required

  def separator?
    return (param_type == 'comma' || param_type == 'newline' || 
            param_type == 'space')
  end
end
