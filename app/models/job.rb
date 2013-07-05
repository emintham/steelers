class Job < ActiveRecord::Base
  attr_accessible :description, :input, :user_id, :server_id, :status,
     :program_id

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
  #validates :input,
  #   :presence => { :on => :create }

  validates_associated :user, :server, :program

  def run
    if completed
      redirect_to root_url, :alert => 'Job has already been completed.'
    else
      prog_name = Program.find(program_id).name

      # output has the format <program_name>_<input>_<job_id>.out
      output = prog_name + '_' + File.basename(input) + 
         '_' + id.to_s + '.out'

      exec_path = Rails.root.join('bin', prog_name).to_s
      userid = User.find(user_id).user_id
      input_path = Rails.root.join('u', userid, input).to_s
      output_path = Rails.root.join('u', userid, output).to_s

      Rails.logger.info "<DEV INFO> input_path: #{input_path}"
      Rails.logger.info "<DEV INFO> output_path: #{output_path}"

      if input == ''
         %x[#{exec_path} > #{output_path}]
      else
         %x[#{exec_path} < #{input_path} > #{output_path}]
         Rails.logger.info "<DEV INFO> command is: #{exec_path} < #{input_path} > #{output_path}"
      end
      update_attribute(:status, false)
      update_attribute(:completed, true)
      update_attribute(:output, output)

      Rails.logger.info "<DEV INFO> run complete, attrs updated"
    end
  end
end
