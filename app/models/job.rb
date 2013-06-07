class Job < ActiveRecord::Base
  attr_accessible :description, :input, :output, :owner, :server, :status
end
