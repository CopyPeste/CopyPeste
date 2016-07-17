require './Fdf_config_handler.rb'

file_access = Fdf_config_handler.new()

puts "Generate file"

print file_access.comments_of("c")
print file_access.comments_of("cpp")
print file_access.ignored_ext
#file_access.dump_config()
