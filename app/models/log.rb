class Log < ActiveRecord::Base
  attr_accessible :input, :output, :job_id, :user_id, :server_id

  # ----------------- Associations -------------------------------------
  belongs_to :job
  belongs_to :user
  belongs_to :server

  # ----------------- Validations ---------------------------------------
  validates_associated :user, :job, :server
end
