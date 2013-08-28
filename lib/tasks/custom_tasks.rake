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
  
  dir_name = "/#{str}"
  puts "Checking for #{dir_name}"
  dir = Rails.root.join(str).to_s
  if File.directory?(dir)
    puts "#{dir_name} exists! Nothing done.\n\n"
  else
    puts "#{dir_name} does not exist! Creating directory"
    Dir.mkdir(dir,permission) unless File.directory?(dir)
    puts "#{dir_name} created!\n\n"
  end
end

def clear_dir(str)
  dir_name = "/#{str}"
  dir = Rails.root.join(str).to_s
  if File.directory?(dir)
    puts "Removing #{dir_name}"
    FileUtils.remove_dir dir
    puts "#{dir_name} removed!\n\n"
  else
    puts "#{dir_name} does not exist! Nothing done.\n\n"
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
    puts "---------------- Directories initialized -----------------------\n\n"
  end

  desc "Initializes directories for users in database"
  task :check_user_dir => :environment do
    permission = 0700

    puts "------------ Task: Checking user directories in /u -------------"
    puts " Checking /u ..."
    User.all.each do |user|
      user_dir = Rails.root.join('u', user.user_id).to_s
      if File.directory?(user_dir)
        puts "  #{user.user_id} has directory! Nothing done."
      else
        puts "  #{user.user_id} does not have directory!"
        Dir.mkdir(user_dir,permission) unless File.directory?(user_dir)
        puts "  /u/#{user.user_id} created!\n\n"
      end
    end

    puts " Checking /confs ..."
    User.all.each do |user|
      user_dir = Rails.root.join('confs', user.id.to_s).to_s
      if File.directory?(user_dir)
        puts "  #{user.user_id} has directory! Nothing done."
      else
        puts "  #{user.user_id} does not have directory!"
        Dir.mkdir(user_dir,permission) unless File.directory?(user_dir)
        puts "  /confs/#{user.id} created!\n\n"
      end
    end
    
    puts "---------------- Finished checking user directories ------------\n\n"
  end

  desc "Retrieves programs in /bin and enters them into database"
  task :retrieve_program => :environment do
    puts "---------------- Task: Retrieving programs from /bin -----------"
    bin_dir = Rails.root.join('bin').to_s

    Dir.chdir(bin_dir) do
      puts " Reading sym-links from /bin ..."
      bins = Dir.glob("*")                  # Ignore hidden files

      if bins.empty?
        puts " Empty /bin directory. Nothing done."
      else
        bins.each do |bin|
          puts "  Found #{bin}"
          if Program.find_by_name(bin) 
            puts "  #{bin} already in database. Nothing done."
          elsif !File.executable?(bin) 
            puts "  #{bin} is not an executable! Nothing done."
          elsif !File.symlink?(bin)
            puts "  #{bin} is not a symbolic link! Nothing done."
          else
            ln_path = Rails.root.join('bin',bin).to_s
            abs_path = %x(readlink -f #{ln_path}).rstrip
            Program.create({ :name => bin, :abs_path => abs_path,
              :folder_specific => false })
            puts "  Added program: #{bin}"
            puts "  #{bin}'s absolute path = #{abs_path}"
          end
        end
      end
      puts " Finished reading sym-links, chdir back to original directory ..."
    end

    puts "--------------- Finished reading programs from /bin ------------\n\n"
  end


  # //////////////////////////////////////////////////////////////////////
  # // Reset tasks
  # //////////////////////////////////////////////////////////////////////
  desc "Clears user directories and uploads after a database reset"
  task :reset do
    dirs = ['u', 'uploads', 'confs']
    puts "----------- Task: Clearing user directories and uploads --------"

    dirs.each do |d|
      puts " Clearing #{d}"
      clear_dir(d)
      puts ""
    end
    puts "---------------- Directories cleared ---------------------------\n\n"
  end
  
  desc "Clears configuration templates"
  task :clear_templates do
    puts "---------------- Task: Clearing Templates ----------------------"
    clear_dir('config_templates')
    puts "---------------- Templates cleared -----------------------------\n\n"
  end

  desc <<-DESC
Clears database and reseeds
Clears user directories, uploads, imported configs, config templates
Recreates empty directories and repopulate as necessary
Retrieves programs
DESC
  task :refresh => :environment do
    Rake::Task['db:reset'].execute
    Rake::Task['db:seed'].execute
    commands = ['reset', 'clear_templates', 'global_dir', 
      'check_user_dir', 'retrieve_program']
    commands.each do |sub|
      f = "custom_tasks:#{sub}"
      Rake::Task[f].execute
    end
  end
end
