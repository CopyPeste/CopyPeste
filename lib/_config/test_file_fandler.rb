
require './file_handler/file_YAML_access_control.rb'
require 'colorize'

file_access = File_YAML_access_control.new()

puts "Generate file"
file_access.load_file()

puts "\n------------- Display File Content ---------------------\n".yellow
file_access.display_elements_file()

file_access.add_ignore_file("elem1")
file_access.add_ignore_file("elem2")
file_access.add_ignore_extension(".elem3")
file_access.add_ignore_extension(".elem4")
file_access.add_compare_extension([".elem5", ".elem6"])
file_access.add_compare_extension([".elem7", ".elem8"])
puts "\n------------- Added elements ---------------------\n".green

puts "\n------------- Display File Content ---------------------\n".yellow
file_access.display_elements_file()

file_access.delete_ignore_file("elem1")
file_access.delete_ignore_extension(".elem3")
file_access.delete_compare_extension([".elem7", ".elem8"])
puts "\n------------- Removed elements ---------------------\n".red

puts "\n------------- Display File Content ---------------------\n".yellow
file_access.display_elements_file()

puts "\n------------- Display Each Content ---------------------".blue
puts "\nGet ignore file".light_blue
puts file_access.get_ignore_file()
puts "\nGet ignore extension".light_blue
puts file_access.get_ignore_extension()
puts "\nGet compare extension".light_blue
file_access.get_compare_extension().each do |elem|
  puts elem
  puts "\n"
end

file_access.finish()
