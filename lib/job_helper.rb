require 'error_helper'
require 'dyna_helper'

# ///////////////////////////////////////////////////////////////////////
# // Helper to execute jobs
# ///////////////////////////////////////////////////////////////////////

class JobHelper
  include Dev       # For logging

  def initialize(job_instance)
    @job      = Job.find(job_instance.id) if job_instance
    @user     = User.find(@job.user_id) if @job
    @program  = Program.find(@job.program_id) if @job
    @prog_name = @program.name if @program
    @exec_path = Rails.root.join('bin', @prog_name).to_s if @prog_name
    @input    = @job.input if @job

    # Set type of program
    if @job && @job.folder_specific
      @type = :dyna
    elsif @job && !@job.folder_specific
      @type = :other
    else
      log "JobHelper ERROR: #{@job.name}'s folder specificity not defined!"
    end

    generate_output_name
  end

  # return an output filename (only needed for jobs other than ls-dyna)
  # outputfile has name <prog_name>_<input_filename>_<job_id>.out
  # and resides in u/<user_id>
  def generate_output_name
    input_basename = File.basename(@job.input) if @job
    @output_name = "#{@prog_name}_#{input_basename}_#{@job.id}.out"
  end

  # Execute jobs of type other than LS-DYNA
  def execute_other
    @input_path = Rails.root.join('confs', @user.id.to_s, @input).to_s if @user && @input
    @u_path = Rails.root.join('u', @job.user_id) if @job
    @output_path = @u_path.join(@output_name).to_s if @output_name
    @error_path = @u_path.join("#{@job.id}_error.log") if @job
    log "JobHelper ERROR: Executing #{@job.name}..."
    log "JobHelper: input_path: #{@input_path}"
    log "JobHelper: output_path: #{@output_path}"
    log "JobHelper: error_path: #{@error_path}"

    %x(#{@exec_path} < #{@input_path} > #{@output_path} 2> #{@error_path} &)
    return true
  end

  # Execute jobs of type DYNA
  # We'll redirect stdout of qsub to ex.out and stderr to ex.err to check
  # if command was successful and return
  # We'll also assume users do not have any non-submission files that
  # matches sub_*
  def execute_dyna(num_procs)
    d = DynaHelper.new(@user,@job,@job.input,@program.dyna_type)
    log "JobHelper: Calling DynaHelper to set up directories"

    if d.expand
      log "JobHelper: DynaHelper expanded successfully, executing..."

      # Set up variables and execute
      @base_path = Rails.root.join('confs',@user.id.to_s,'dyna',@job.id.to_s) if @job && @user
      @input_path = @base_path.to_s if @job && @user
      Dir.chdir(@input_path) do
        files = Dir.glob("sub_*")
        submission = files.first if !files.empty?
        %x(qsub -pe mpi #{@job.num_procs} #{submission} > ex.out 2> ex.err &)

        log "JobHelper: chdir into #{@input_path}"
        log "JobHelper: found #{files}"
        log "JobHelper: executing 'qsub -pe mpi #{@job.num_procs} #{submission} > ex.out 2> ex.err &"
      end
      err_path = @base_path.join('ex.err').to_s
      return File.exists?(err_path) && File.zero?(err_path)
    else
      log "JobHelper ERROR: unable to expand zip"
      return false
    end
  end

  # This is the function to be called externally
  def execute
    case @type
    when :dyna
      return execute_dyna
    when :other
      return execute_other
    else
      logs "JobHelper ERROR: Trying to execute a job with undefined type!"
      return false
    end
  end
end
