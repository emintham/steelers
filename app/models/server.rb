class Server < ActiveRecord::Base
  attr_accessible :ip, :name

  has_many :jobs
  has_many :programs
  has_many :logs

  validates_presence_of :ip, :on => :create
  validates_presence_of :name, :on => :create
end
