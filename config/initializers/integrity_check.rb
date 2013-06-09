# Initialize RAILS_ROOT/u/ for user files
# User with user_id johnsmith123 will have a folder in 
# RAILS_ROOT/u/johnsmith123
# (see User controller for more info)

# Global Directory
Rails.logger.info "<DEV INFO> Running Integrity Checks..."
Rails.logger.info "<DEV INFO> 1. Checking <RAILS_ROOT>/u/"
global_dir = Rails.root.join('u').to_s
global_permission = 0770
if File.directory?(global_dir)
  Rails.logger.info "<DEV INFO> <RAILS_ROOT>/u/ exists!"
else
  Rails.logger.info "<DEV INFO> <RAILS_ROOT>/u/ does not exist!"
  Dir.mkdir(global_dir,global_permission) unless File.directory?(global_dir)
  Rails.logger.info "<DEV INFO> <RAILS_ROOT>/u/ created!"
end

# User directories
Rails.logger.info "<DEV INFO> 2. Checking <RAILS_ROOT>/u/<user_id>"
User.all.each do |user|
  user_dir = Rails.root.join('u', user.user_id).to_s
  user_permission = 0700
  if File.directory?(user_dir)
    Rails.logger.info "<DEV INFO> #{user.user_id} has directory!"
  else
    Rails.logger.info "<DEV INFO> #{user.user_id} does not have directory!"
    Dir.mkdir(user_dir,user_permission) unless File.directory?(user_dir)
    Rails.logger.info "<DEV INFO> <RAILS_ROOT>/u/#{user.user_id} created!"
  end
end
