class Job < ActiveRecord::Base
  attr_accessible :description, :input, :user_id, :server, :status

  belongs_to :user,
    :counter_cache => :num_jobs,   # keep track of number of jobs/user
    :touch => true                 # update user when user adds job

  belongs_to :server, 
    :counter_cache => :num_jobs,   # keep track of number of jobs/server
    :touch => true                 # update server when user adds job

  has_many :logs

  # ----------------- Validations --------------------------------------
  validates :server,
     :presence => true

  validates :input,
     :presence => true

  validates_associated :user, :server
end
