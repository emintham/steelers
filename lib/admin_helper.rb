# ///////////////////////////////////////////////////////////////////////
# // Helper for Admin Information
# ///////////////////////////////////////////////////////////////////////

require 'error_helper'

module AdminHelper

  # ---------------------------------------------------------------------
  # | Data structure representing hard disk usage of each user
  # ---------------------------------------------------------------------
  class Usage
    include Dev
    attr_accessor :content

    def initialize(user_instance)
      log "AdminHelper::Usage attempting to initialize instance for #{user_instance}"

      if user_instance
        @user = User.find(user_instance.id)
        @content = Hash.new
        @content[:user] = @user.id
        @content[:total] = 0
        log "AdminHelper::Usage initialized instance for #{@user.user_id}"

        if query_all
          log "AdminHelper::Usage #{@content[:user]}'s usage updated!"
        else
          log "AdminHelper::Usage ERROR in updating usage!"
        end
      else
        log "AdminHelper::Usage ERROR: Invalid user = #{user_instance}"
      end
    end

    # Returns space usage of user's folder
    def query_usage(folder)
      log "AdminHelper::Usage checking #{folder} usage of #{@content[:user]}"
      path = Rails.root.join(folder,@user.id.to_s).to_s
      if Dir.exists?(path)
        size = File.size(path)
        @content[:total] += size
        @content[folder.to_sym] = size

        log "AdminHelper::Usage #{path} has #{size} bytes"
        return true
      else
        log "AdminHelper::Usage #{folder} not found!"
        return false
      end
    end

    # Calls query_usage on all of the user's directories
    def query_all
      folders = ['confs', 'u', 'uploads']
      folders.each do |folder|
        return false unless query_usage(folder)
      end
      return true
    end

    def total
      return @content[:total]
    end
  end
end
