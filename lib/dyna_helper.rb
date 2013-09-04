# //////////////////////////////////////////////////////////////////////
# // Helper for creating a directory to run LS-DYNA jobs
# //////////////////////////////////////////////////////////////////////

require 'zipruby'
require 'fileutils'
require 'error_helper'

# Assumptions:
# - User will upload a zip file containing a deck file with extension (.k)
#   and there will only be one .k file in the zip.
# - For LS-DYNA to function properly, zip file should not contain 
#   directories
#
# Summary:
# Given a zip file containing a deck file for LS-DYNA and possibly
# other included files residing in /uploads/@user.id/
# - Copy zip to a /confs/@user.id/dyna/@job.id/
# - Unzip it
# - Remove the zip file
# - Verifies that a deck file exists (.k) and creates a standard config 
#   file for dyna. 

class DynaHelper
  include Dev     # for logging

  def initialize (user, job, filename, flag)
    @user = User.find(user.id) if user
    @job = Job.find(job.id) if job
    @filename = filename
    @filepath = Rails.root.join('uploads', @user.id.to_s, filename).to_s if (@user && filename)
    @program = Program.find(@job.program_id) if @job
    if flag == 'smp' || flag == 'mpp'
      @flag = flag
    else
      log "DynaHelper ERROR in initialize => flag = #{flag}"
    end

    log "DynaHelper initializing...."
    log "user = #{@user.user_id}" if @user
    log "job = #{@job.id}" if @job
    log "filepath = #{@filepath}" if @filepath
  end

  # helper to report error
  def report_error
    log "DynaHelper ERROR: #{@new_filepath} not created?"
    return false
  end

  def cp
    @new_filepath = Rails.root.join('confs',@user.id.to_s,'dyna')
    if Dir.exist?(@new_filepath.to_s)
      @new_filepath = @new_filepath.join(@job.id.to_s).to_s
      permission = 0700

      log "DynaHelper creating #{@new_filepath}"
      FileUtils.mkdir_p @new_filepath

      log "DynaHelper copying #{@filepath} to #{@new_filepath}"
      FileUtils.cp @filepath, @new_filepath

      log "DynaHelper copied #{@filepath} to #{@new_filepath}"
      return true
    else
      @new_filepath = @new_filepath.to_s
      return report_error
    end
  end

  # Extract files:
  #  extraction code from https://bitbucket.org/winebarrel/zip-ruby/wiki/Home
  def unzip
    if @new_filepath
      log "DynaHelper chdir into #{@new_filepath}"

      Dir.chdir(@new_filepath) do
        @new_filepath += "/#{@filename}"
        log "DynaHelper extracting zip in #{@new_filepath}"
        Zip::Archive.open(@new_filepath) do |ar|
          ar.each do |zf|
            if zf.directory?
              FileUtils.mkdir_p(zf.name)
            else
              dirname = File.dirname(zf.name)
              FileUtils.mkdir_p(dirname) unless File.exist?(dirname)

              open(zf.name, 'wb') do |f|
                f << zf.read
              end
            end
          end
        end
      
        log "DynaHelper finished extracting #{@new_filepath}"
      end

      return true
    else
      return report_error
    end
  end

  def rm_zip
    if @new_filepath
      log "DynaHelper removing zip at #{@new_filepath} ..."
      FileUtils.rm @new_filepath
      log "DynaHelper removed zip #{@new_filepath}"
      return true
    else
      return report_error
    end
  end

  def verify_deck
    if @user && @job
      path = Rails.root.join('confs',@user.id.to_s,'dyna',@job.id.to_s,'*.k').to_s
      log "DynaHelper: verifying deck file at #{path}"
      glob = Dir.glob(path)
      if !glob.empty? && glob.size == 1
        @deck = File.basename(glob[0])
        log "DynaHelper: deck found: #{@deck}"
      else
        log "DynaHelper ERROR: either more than one .k files found or none found!"
        log "Found: #{glob}"
        return false
      end
      return true
    else
      log "DynaHelper ERROR: verify_deck cannot find @user or @job"
      log "@user = #{@user.user_id}" if @user
      log "@job = #{@job.id}" if @job
      return false
    end
  end

  # Create config for MPP
  def create_config_mpp
    if @program && @job
      @new_file = Rails.root.join('confs',@user.id.to_s,'dyna',@job.id.to_s,'sub_lsdynampp')
      log "DynaHelper: creating new mpp config at #{@new_file}"

      File::open(@new_file,'w') do |f|
        f << <<-HEADER
#!/bin/bash
#\$ -N steelers#{@job.id}
#\$ -S /bin/bash
#\$ -cwd          ## use current working directory for batch execution
#\$ -j y          ## Stream error output into standard output   
#\$ -q single.q

module load lsdyna
module load hp-mpi

MACHINES=$JOB_NAME.hosts.$JOB_ID
awk '/^compute/ {for (i=1; i<=$2; i++) print $1}' $PE_HOSTFILE > $MACHINES
mpirun -np $NSLOTS -v -hostfile $TMPDIR/machines #{@program.abs_path} i=#{@deck} >run.log
HEADER
      end
      log "DynaHelper successfully created #{@new_file}."
      return true
    else
      log "DynaHelper ERROR in create_config_mpp: @job not defined!"
      return false
    end
  end

  # Create config for SMP
  def create_config_smp
    if @program && @job
      @new_file = Rails.root.join('confs',@user.id.to_s,'dyna',@job.id.to_s,'sub_lsdynasmp')
      log "DynaHelper: Creating new smp config at #{@newfile}"

      File::open(@new_file,'w') do |f|
        f << <<-HEADER
#!/bin/bash
#\$ -N steelers#{@job.id}
#\$ -S /bin/bash
#\$ -cwd          ## use current working directory for batch execution
#\$ -j y          ## Stream error output into standard output   
#\$ -q single.q

module load lsdyna

#{@program.abs_path} i=#{@deck} >run.log
HEADER
      end
      log "DynaHelper successfully created #{@new_file}."
      return true
    else
      log "DynaHelper ERROR in create_config_smp: @job not defined!"
      return false
    end
  end

  # Wraps every operation above
  def expand
    precreate_success = cp && unzip && rm_zip && verify_deck
    if precreate_success && @flag == 'smp'
      log "DynaHelper: precreate success, creating SMP config"
      return create_config_smp
    elsif precreate_success && @flag == 'mpp'
      log "DynaHelper: precreate success, creating MPP config"
      return create_config_mpp
    else
      log "DynaHelper: either precreate failed or @flag not set!"
      log "DynaHelper: flag = #{@flag}"
      return false
    end
  end
end
