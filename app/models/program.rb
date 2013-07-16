class Program < ActiveRecord::Base
  attr_accessible :name, :server_id

  # ------------------ Associations ------------------------------------
  has_many :jobs, :configs
  belongs_to :server

  # ------------------ Validations -------------------------------------
  validates :name,
    :presence => { :on => :create },
    :uniqueness => true
end
