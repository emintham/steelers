class ConfigTemplate < ActiveRecord::Base
  attr_accessible :name, :fields_attributes, :program_id

  has_many :fields, class_name: "ConfigParam"
  belongs_to :program

  accepts_nested_attributes_for :fields, allow_destroy: true
end
