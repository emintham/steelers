# ///////////////////////////////////////////////////////////////////////
# // Helper for error logging
# // To use:
# //
# //    require 'error_helper'
# //    
# //    class MyClass
# //      include Dev
# //  
# //      def my_function
# //        log "MY ERROR MESSAGE"
# //        ...
# //      end
# //    end
# ///////////////////////////////////////////////////////////////////////
module Dev
  def log str
    Rails.logger.info("DEV INFO:: " + str)
  end
end
