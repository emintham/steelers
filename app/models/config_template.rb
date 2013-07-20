class ConfigTemplate < ActiveRecord::Base
  attr_accessible :name, :fields_attributes, :program_id

  # -------------- Associations ---------------------------------------
  has_many :fields, class_name: "ConfigParam"
  belongs_to :program

  accepts_nested_attributes_for :fields, allow_destroy: true

  # --------------- Custom Methods ------------------------------------
  after_create :write_to_file
  
  protected
  def write_to_file
    # Filename should not contain spaces
    filepath = Rails.root.join('config_templates', name.gsub(/ /, '_')).to_s

    unless File.exists?(filepath)
      f = File.new(filepath, "w")
      fields.each do |field|
        if (field.param_type == 'text' || field.param_type == 'number')
          f.write("#{field.name}")
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
