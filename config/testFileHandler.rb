
require './fileHandler/fileYAMLAccessControl.rb'
require 'colorize'

fileAccess = FileYAMLAccessControl.new()

puts "Generate file"
fileAccess.loadFile()

puts "\n------------- Display File Content ---------------------\n".yellow
fileAccess.displayElementsFile()

fileAccess.addIgnoreFile("elem1")
fileAccess.addIgnoreFile("elem2")
fileAccess.addIgnoreExtension(".elem3")
fileAccess.addIgnoreExtension(".elem4")
fileAccess.addCompareExtension([".elem5", ".elem6"])
fileAccess.addCompareExtension([".elem7", ".elem8"])
puts "\n------------- Added elements ---------------------\n".green

puts "\n------------- Display File Content ---------------------\n".yellow
fileAccess.displayElementsFile()

fileAccess.deleteIgnoreFile("elem1")
fileAccess.deleteIgnoreExtension(".elem3")
fileAccess.deleteCompareExtension([".elem7", ".elem8"])
puts "\n------------- Removed elements ---------------------\n".red

puts "\n------------- Display File Content ---------------------\n".yellow
fileAccess.displayElementsFile()

puts "\n------------- Display Each Content ---------------------".blue
puts "\nGet ignore file".light_blue
puts fileAccess.getIgnoreFile()
puts "\nGet ignore extension".light_blue
puts fileAccess.getIgnoreExtension()
puts "\nGet compare extension".light_blue
fileAccess.getCompareExtension().each do |elem|
  puts elem
  puts "\n"
end

fileAccess.finish()
