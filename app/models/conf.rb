class Conf < ActiveRecord::Base
  belongs_to :program
  attr_accessible :name
end
