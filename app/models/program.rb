class Program < ActiveRecord::Base
  attr_accessible :name, :server_id

  # ------------------ Associations ------------------------------------
  has_many :jobs
  belongs_to :server
  has_one :config_template

  # ------------------ Validations -------------------------------------
  validates :name,
    :presence => { :on => :create },
    :uniqueness => true
end
