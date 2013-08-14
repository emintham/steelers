class AddAttachmentUploadToUserfiles < ActiveRecord::Migration
  def self.up
    change_table :userfiles do |t|
      t.attachment :upload
    end
  end

  def self.down
    drop_attached_file :userfiles, :upload
  end
end
