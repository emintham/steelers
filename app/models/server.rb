class Server < ActiveRecord::Base
  attr_accessible :ip, :name

  has_many :jobs
  has_many :programs
  has_many :logs
end
