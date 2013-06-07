class Log < ActiveRecord::Base
  attr_accessible :input, :job_id, :output, :user_id
end
