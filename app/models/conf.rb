class Conf < ActiveRecord::Base
  attr_accessible :name, :config_template_id, :properties, :user_id

  # ---------------------- Associations -------------------------------
  belongs_to :config_template
  belongs_to :user

  serialize :properties, Hash

  # ---------------------- Validations --------------------------------
  validate :validate_properties

  # ---------------------- Custom Methods -----------------------------
  after_create :write_to_file

  def validate_properties
    config_template.fields.each do |field|
      if field.required? && properties[field.name].blank?
        errors.add field.name, "must not be blank" unless (field.param_type == 'comma' || field.param_type == 'newline')
      end
    end
  end

  def write_to_file
    # Filename should not contain spaces
    filepath = Rails.root.join('confs', name.gsub(/ /, '_')).to_s

    unless File.exists?(filepath)
      f = File.new(filepath, "w")
      config_template.fields.each do |field|
        if (field.param_type == 'text' || field.param_type == 'number')
          f.write(properties[field.name])
        elsif field.param_type == 'comma'
          f.write(", ")
        elsif field.param_type == 'newline'
          f.write("\n")
        end
      end
      f.close
    end
  end
end
