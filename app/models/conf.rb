class Conf < ActiveRecord::Base
  attr_accessible :name, :config_template_id, :properties

  belongs_to :config_template

  serialize :properties, Hash

  validate :validate_properties

  def validate_properties
    config_template.fields.each do |field|
      if field.required? && properties[field.name].blank?
        errors.add field.name, "must not be blank"
      end
    end
  end
end
