## Retrieve list of programs from /bin/
#bin_dir = Rails.root.join('bin').to_s
#permission = 0111
#Dir.mkdir(bin_dir,permission) unless File.directory?(bin_dir)
#
## save current dir to get back later
#root_dir = Dir.pwd
#Dir.chdir(bin_dir)
#
## read all programs from /bin/
#@bins = Dir.glob("*") # Ignore hidden files
#@bins.each do |bin|
#  if !Program.find_by_name(bin) && File.executable?(bin) && File.symlink?(bin)
#    Program.create({ :name => bin })
#    Rails.logger.info("<DEV INFO> creating program" + bin)
#  end
#end
#
## change back to original dir
#Dir.chdir(root_dir)
