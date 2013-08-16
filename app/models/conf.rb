class Conf < ActiveRecord::Base
  attr_accessible :name, :config_template_id, :properties, :user_id

  # ---------------------- Associations -------------------------------
  belongs_to :config_template
  belongs_to :user

  serialize :properties, Hash

  # ---------------------- Validations --------------------------------
  validate :validate_properties
  validates_presence_of :user_id, :on => :create

  # ---------------------- Custom Methods -----------------------------
  after_create :write_to_file

  def validate_properties
    config_template.fields.each do |field|
      if field.required? && properties[field.name].blank?
        errors.add field.name, "must not be blank" unless field.separator?
      end
    end
  end

  protected
  def write_to_file
    # Filename should not contain spaces
    filename = name.gsub(/ /, '_') + id.to_s
    filepath = Rails.root.join('confs', user_id, filename).to_s

    unless File.exists?(filepath)
      f = File.new(filepath, "w")
      config_template.fields.each do |field|
        if (field.param_type == 'text' || field.param_type == 'number')
          f.write(properties[field.name])
        elsif field.param_type == 'space'
          f.write(" ")
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
