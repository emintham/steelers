# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'ROLES'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end

puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, 
  :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup,
  :password_confirmation => ENV['ADMIN_PASSWORD'].dup,
  :user_id => ENV['ADMIN_USERID'].dup
puts 'superuser: ' << user.user_id 
user.add_role :admin
user.save!

user = User.find_or_create_by_email :name => 'Joe Smith',
  :email => 'abc@gmail.com', :password => 'password',
  :password_confirmation => 'password', :user_id => 'normal_user'
puts 'normaluser: ' << user.user_id
user.add_role :user
user.save!

user = User.find_or_create_by_email :name => 'Eugene',
  :email => 'eugene@gmail.com', :password => 'password',
  :password_confirmation => 'password', :user_id => 'ystarase'
puts 'normaluser: ' << user.user_id
user.add_role :user
user.save!

puts 'DEFAULT SERVERS'
server = Server.find_or_create_by_name :name => 'steelers.uwaterloo.ca', :ip => '129.97.185.93'
puts 'server: ' << server.name
puts 'ip: ' << server.ip
server.save!

server = Server.find_or_create_by_name :name => 'linux028.student.cs.uwaterloo.ca', :ip => '129.97.167.52'
puts 'server: ' << server.name
puts 'ip: ' << server.ip
server.save!
