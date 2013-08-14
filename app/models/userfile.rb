class Userfile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :name, :upload, :user_id

  has_attached_file :upload,
    :path => ':rails_root/uploads/:user_id/:basename'

  validates_attachment :upload, :presence => true

  def valid_format?
    query = %x(file -b --mime-type #{upload.path})  
    Rails.logger.info "DEV INFO:: format = #{query}"
    return false unless query == 'text/plain'
  end
end
