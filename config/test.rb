
require './fileHandle/fileYAMLAccessControl.rb'

fileAccess = FileYAMLAccessControl.new()

fileAccess.loadFile()
fileAccess.affFile()
fileAccess.addIgnoreFile("test")
fileAccess.addIgnoreFile("test2")
fileAccess.addIgnoreExtension(".test")
fileAccess.addIgnoreExtension(".test2")
fileAccess.addCompareExtension([".a", ".b"])
fileAccess.affFile()

fileAccess.deleteIgnoreFile("test")
fileAccess.deleteIgnoreExtension("test2")

puts "\n\nignore file"
puts fileAccess.getIgnoreFile()
puts "\nignore ext"
puts fileAccess.getIgnoreExtension()
puts "\ncompare ext"
fileAccess.getCompareExtension().each do |elem|
  puts elem
  puts "\n"
end

fileAccess.finish()
