require 'error_helper'

class Conf < ActiveRecord::Base
  include Dev

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

  # Writes config to file
  def write_to_file
    # Filename should not contain spaces
    filepath = Rails.root.join('confs', user_id.to_s, name).to_s
    log "Conf Model: filepath = #{filepath}"

    unless File.exists?(filepath)
      f = File.new(filepath, "w")
      log "Conf Model: creating file..."

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
      log "Conf Model: done writing file, closing..."
    end
  end
end
