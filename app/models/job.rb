require 'error_helper'
require 'job_helper'

class Job < ActiveRecord::Base
  include Dev           # for logging

  attr_accessible :description, :input, :user_id, :server_id, :status,
     :program_id

  attr_accessor :num_procs

  # --------------- Associations ---------------------------------------
  belongs_to :user,
    :counter_cache => :num_jobs,   # keep track of number of jobs/user
    :touch => true                 # update user when user adds job

  belongs_to :server, 
    :counter_cache => :num_jobs,   # keep track of number of jobs/server
    :touch => true                 # update server when user adds job

  belongs_to :program

  has_many :logs

  # ----------------- Validations --------------------------------------
  validates_associated :user, :server, :program

  # Calls the job helper to execute job based on job's type (is it ls-dyna?
  #  is it mpi? etc.) and parameters
  def run
     user = User.find(:user_id).user_id
     if completed
        redirect_to root_url, :alert => 'Job has already been completed!'
        log "Job Model: #{user} attempted to execute completed job."
     else
        # initialize JobHelper based on current instance
        j = JobHelper.new(self)     
        log "Job Model: #{user} executing job #{id}"

        # Attempt to execute job- check return codes
        if j.execute
           update_attribute(:status, false)
           update_attribute(:completed, true)
           update_attribute(:output, output)
           log "Job Model: Job #{id} by User #{user} completed!"
           redirect_to root_url, :notice => 'Job submitted!'
        else
           log "Job Model ERROR: unable to complete job!"
           redirect_to root_url, :alert => 'Error in submitting job! Please contact administrator.'
        end
     end
  end
end
