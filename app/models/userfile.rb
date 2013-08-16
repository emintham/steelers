require 'config_importer'

class Userfile < ActiveRecord::Base
  belongs_to :user
  belongs_to :type, class_name: "ConfigTemplate"
  attr_accessible :name, :upload, :user_id, :type_id

  has_attached_file :upload,
    :path => ':rails_root/uploads/:user_id/:basename.:extension.:id'

  validates_attachment_presence :upload
  validates_presence_of :type_id, :on => :create
  validates_presence_of :user_id, :on => :create

  def valid_format?
    if upload.original_filename == nil
      Rails.logger.info "DEV INFO:: No file found!"
      return true
    else
      query = %x(file -b --mime-type #{upload.path})  
      Rails.logger.info "DEV INFO:: format = #{query}"
      return query == "text/plain\n"
    end
  end

  def import(template_id)
    @user = User.find(user_id)
    @template = ConfigTemplate.find(template_id)

    @conf = ConfigImporter.new(@user,@template,upload.path)
    @conf.execute

    return @conf.success
  end
end
