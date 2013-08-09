require 'fileutils'

# ///////////////////////////////////////////////////////////////////////
# // Custom Tasks for database/directory management
# //
# //  Note: Dir.mkdir(...) unless File.directory?(...) is really for
# //        paranoia-- it does not guarantee atomicity. If a malicious
# //        user gains access to the cluster, there is nothing to prevent
# //        him/her from removing/changing the directory in between the
# //        the check and creation of a directory-- even with Mutex.
# ///////////////////////////////////////////////////////////////////////

def dir_check(str)
  permission = 0700
  
  dir_name = "/" + str
  puts "Checking for " + dir_name
  dir = Rails.root.join(str).to_s
  if File.directory?(dir)
    puts dir_name + " exists! Nothing done."
    puts ""
  else
    puts dir_name + " does not exist! Creating directory"
    Dir.mkdir(dir,permission) unless File.directory?(dir)
    puts dir_name + " created!"
    puts ""
  end
end

def clear_dir(str)
  dir_name = "/" + str
  dir = Rails.root.join(str).to_s
  if File.directory?(dir)
    puts "Removing " + dir_name
    FileUtils.remove_dir dir
    puts dir_name + " removed!"
    puts ""
  else
    puts dir_name + " does not exist! Nothing done."
    puts ""
  end
end

namespace :custom_tasks do

  # //////////////////////////////////////////////////////////////////////
  # // Initialization tasks
  # //////////////////////////////////////////////////////////////////////
  desc "Creates global directories"
  task :global_dir do
    dirs = ['u', 'bin', 'config_templates', 'confs', 'uploads']
    puts "---------------- Task: Initializing directories ----------------"

    dirs.each do |d|
      dir_check(d)
    end
    puts "---------------- Directories initialized -----------------------"
    puts ""
  end

  desc "Initializes directories for users in database"
  task :check_user_dir => :environment do
    permission = 0600

    puts "------------ Task: Checking user directories in /u -------------"
    puts " Checking /u ..."
    User.all.each do |user|
      user_dir = Rails.root.join('u', user.user_id).to_s
      if File.directory?(user_dir)
        puts "  #{user.user_id} has directory! Nothing done."
      else
        puts "  #{user.user_id} does not have directory!"
        Dir.mkdir(user_dir,permission) unless File.directory?(user_dir)
        puts "  /u/#{user.user_id} created!"
        puts ""
      end
    end

    puts " Checking /confs ..."
    User.all.each do |user|
      user_dir = Rails.root.join('confs', user.user_id).to_s
      if File.directory?(user_dir)
        puts "  #{user.user_id} has directory! Nothing done."
      else
        puts "  #{user.user_id} does not have directory!"
        Dir.mkdir(user_dir,permission) unless File.directory?(user_dir)
        puts "  /confs/#{user.user_id} created!"
        puts ""
      end
    end
    
    puts "---------------- Finished checking user directories ------------"
    puts ""
  end

  desc "Retrieves programs in /bin and enters them into database"
  task :retrieve_program => :environment do
    permission = 0100

    puts "---------------- Task: Retrieving programs from /bin -----------"
    bin_dir = Rails.root.join('bin').to_s
    File.chmod(permission, bin_dir)

    puts " Saving current directory and chdir into /bin ..."
    root_dir = Dir.pwd
    Dir.chdir(bin_dir)

    puts " Reading sym-links from /bin ..."
    bins = Dir.glob("*")                  # Ignore hidden files
    if bins.empty?
      puts " Empty /bin directory. Nothing done."
    else
      bins.each do |bin|
        puts "  Found " + bin
        if Program.find_by_name(bin) 
          puts "  " + bin + " already in database. Nothing done."
        elsif !File.executable?(bin) 
          puts "  " + bin + " is not an executable! Nothing done."
        elsif !File.symlink?(bin)
          puts "  " + bin + " is not a symbolic link! Nothing done."
        else
          Program.create({ :name => bin })
          puts "  Added program: " + bin
          puts ""
        end
      end
    end

    puts " Finished reading sym-links, chdir back to original directory ..."
    Dir.chdir(root_dir)
    puts "--------------- Finished reading programs from /bin ------------"
    puts ""
  end


  # //////////////////////////////////////////////////////////////////////
  # // Reset tasks
  # //////////////////////////////////////////////////////////////////////
  desc "Clears directories after a database reset"
  task :reset do
    dirs = ['u', 'uploads']
    puts "---------------- Task: Clearing directories --------------------"

    dirs.each do |d|
      puts " Clearing " + d
      clear_dir(d)
      puts ""
    end
    puts "---------------- Directories cleared ---------------------------"
    puts ""
  end
  
  desc "Clears configuration templates"
  task :clear_templates do
    puts "---------------- Task: Clearing Templates ----------------------"
    clear_dir('config_templates')
    puts "---------------- Templates cleared -----------------------------"
    puts ""
  end
end
