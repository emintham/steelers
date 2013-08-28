require 'config_importer'
require 'dyna_helper'
require 'error_helper'

class Userfile < ActiveRecord::Base
  include Dev

  belongs_to :user
  belongs_to :type, class_name: "ConfigTemplate"
  attr_accessible :name, :upload, :user_id, :type_id

  has_attached_file :upload,
    :path => ':rails_root/uploads/:user_id/:basename.:extension.:id'

  validates_attachment_presence :upload
  validates_presence_of :type_id, :on => :create
  validates_presence_of :user_id, :on => :create

  # Returns true if upload path contains characters that should not be
  # in a 'normal' file path
  def injection?
    str = upload.path
    return str.include?("|") || str.include?("\&") || str.include?("\;") ||
      str.include?("\`")
  end

  # returns true iff file is of type 'text/plain' or file does not exist
  def valid_format?
    if upload.original_filename == nil
      log "Userfile => No file found!"
      return true
    elsif injection?
      log "Userfile => Possible injection attempt by #{User.find(user_id)}"
      log "Userfile path = #{upload.path}"
      return false
    else
      @filetype = %x(file -b --mime-type #{upload.path})  
      log "format = #{@filetype}"
      return @filetype == "text/plain\n" || @filetype == "application/zip\n"
    end
  end

  def import(template_id)
    @user = User.find(user_id)
    if upload_content_type == "application/octet-stream"
      @template = ConfigTemplate.find(template_id)

      @conf = ConfigImporter.new(@user,@template,upload.path,upload.original_filename)
      @conf.execute

      return @conf.success
    else
      log "userfile ERROR in upload_content_type = #{upload_content_type}"
      return false
    end
  end
end
