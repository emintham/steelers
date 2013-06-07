class Server < ActiveRecord::Base
  attr_accessible :ip, :name, :num_jobs
end
