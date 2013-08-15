# Class to import config instances into app given its template
# Assumptions: 
#   - config to be imported is properly formatted
#       eg. config files from current users of cluster before web app
#   - current assumed comment delimiters are ! #
#   - uploaded files reside in uploads/:user_id/
class ConfigImporter
  attr_reader :success    # to indicate to outside functions whether
                          # import was successful

  def dlog (str)
    Rails.logger.info str
  end

  # Inputs: user's id, template's id, absolute path of input file
  # for absolute path of input file, use userfile.upload.path
  def initialize(user, template, input_file)
    dlog "<DEV INFO> ConfigImporter: initializing config importer..."
    dlog "<DEV INFO> ConfigImporter: user = #{user.name}" if user
    dlog "<DEV INFO> ConfigImporter: input file = #{input_file}" if input_file
    dlog "<DEV INFO> ConfigImporter: template = #{template.name}" if template

    @user         = user if user
    @filename     = File.basename(input_file) if input_file
    @filepath     = Rails.root.join('uploads', @user.id.to_s, @filename).to_s if @user && @filename
    @template     = template if template
    @fields       = @template.fields.reject {|x| x.separator? } if @template # Array
    @params       = Hash.new
    @flag         = false             # has all checks been successful?
    @value_array  = Array.new
    @success      = false
  end

  def filecheck                   # should run before all other tests
    dlog "<DEV INFO> ConfigImporter: checking input file..."

    unless File.exists?(@filepath)
      Rails.logger.info "<DEV INFO> #{@filepath} is not a valid file!"
      @flag = false
    else
      @flag = true
    end
  end

  def strip_comments (str)
    return str.gsub(/(!|#)(.*)/, '')
  end

  def import
    dlog "<DEV INFO> ConfigImporter: Importing configuration values from file..."

    # NOTE: will strip ALL commas and whitespace
    File.open(@filepath, 'r').each_line do |line|
      line = strip_comments line
      @value_array += line.split(%r{,\s*|\s+})
    end
  end

  def arglen_check
    dlog "<DEV INFO> ConfigImporter: checking number of arguments in imported file..."

    if @value_array.length != @fields.length
      dlog "# of imported values does not match # of expected values"
      @flag &= false
    else
      @flag &= true
    end
  end

  def arg_copy
    arglen_check()
    if @flag
      dlog "<DEV INFO> ConfigImporter: copying imported values into new conf..."

      @value_array.each_index do |index|
        param_name = @fields[index].name
        param_value = @value_array[index]
        @params[param_name] = param_value
      end
    else
      dlog "<DEV INFO> ConfigImporter: flag not set to true! Did tests pass?"
    end
  end

  def execute
    dlog "<DEV INFO> ConfigImporter: attempting import..."

    # ---------------------- Atomic operation -------------------------
    # | Checks have to be atomic to ensure integrity
    # | Database transaction has to be atomic
    # -----------------------------------------------------------------
    Conf.transaction do
      filecheck()
      import()
      arg_copy()

      if @user
        Conf.create(name: @filename, config_template_id: @template.id, properties: @params, user_id: @user.id)
      else
        Conf.create(name: @filename, config_template_id: @template.id, properties: @params)
      end
      @success = true unless @flag = false
    end

    dlog "<DEV INFO> ConfigImporter: import completed!"
  end
end
