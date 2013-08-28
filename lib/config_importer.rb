require 'error_helper'

# //////////////////////////////////////////////////////////////////////
# Class to import config instances into app given its template
# Assumptions: 
#   - config to be imported is properly formatted
#       eg. config files from current users of cluster before web app
#   - current assumed comment delimiters are ! #
#   - uploaded files reside in uploads/:user_id/
# //////////////////////////////////////////////////////////////////////
class ConfigImporter
  include Dev

  attr_reader :success    # to indicate to outside functions whether
                          # import was successful

  # Inputs: user's id, template's id, absolute path of input file
  # for absolute path of input file, use userfile.upload.path
  def initialize(user, template, input_file,original_filename)
    log "ConfigImporter: initializing config importer..."
    log "ConfigImporter: user = #{user.name}" if user
    log "ConfigImporter: input file = #{input_file}" if input_file
    log "ConfigImporter: template = #{template.name}" if template

    @user         = user if user
    @filename     = File.basename(input_file) if input_file
    @filepath     = Rails.root.join('uploads', @user.id.to_s, @filename).to_s if @user && @filename
    @template     = template if template
    @fields       = @template.fields.reject {|x| x.separator? } if @template # Array
    @params       = Hash.new
    @flag         = false             # has all checks been successful?
    @value_array  = Array.new
    @success      = false
    @original_filename = original_filename
  end

  def filecheck                   # should run before all other tests
    log "ConfigImporter: checking input file..."

    unless File.exists?(@filepath)
      Rails.logger.info "#{@filepath} is not a valid file!"
      @flag = false
    else
      @flag = true
    end
  end

  def strip_comments (str)
    return str.gsub(/(!|#)(.*)/, '')
  end

  def import
    log "ConfigImporter: Importing configuration values from file..."

    # NOTE: will strip ALL commas and whitespace
    File.open(@filepath, 'r').each_line do |line|
      line = strip_comments line
      @value_array += line.split(%r{,\s*|\s+})
    end
  end

  def arglen_check
    log "ConfigImporter: checking number of arguments in imported file..."

    if @value_array.length != @fields.length
      log "# of imported values does not match # of expected values"
      @flag &= false
    else
      @flag &= true
    end
  end

  def arg_copy
    arglen_check()
    if @flag
      log "ConfigImporter: copying imported values into new conf..."

      @value_array.each_index do |index|
        param_name = @fields[index].name
        param_value = @value_array[index]
        @params[param_name] = param_value
      end
    else
      log "ConfigImporter: flag not set to true! Did tests pass?"
    end
  end

  def execute
    log "ConfigImporter: attempting import..."

    # ---------------------- Atomic operation -------------------------
    # | Checks have to be atomic to ensure integrity
    # | Database transaction has to be atomic
    # -----------------------------------------------------------------
    Conf.transaction do
      filecheck()
      import()
      arg_copy()

      if @user
        Conf.create(name: @original_filename, config_template_id: @template.id, properties: @params, user_id: @user.id)
      else
        log "ConfigImporter ERROR in execute. @user not defined!"
      end
      @success = true unless @flag == false
    end

    log "ConfigImporter: import completed!"
  end
end
