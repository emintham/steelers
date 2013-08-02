class Userfile < ActiveRecord::Base
  attr_accessible :upload
  belongs_to :user
  mount_uploader :upload, UploadUploader
end
