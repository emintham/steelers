class Log < ActiveRecord::Base
  attr_accessible :input, :output

  belongs_to :job
  belongs_to :user
  belongs_to :server

  validates_presence_of :user_id, :job_id, :server_id
  validates_associated :user, :job, :server
end
