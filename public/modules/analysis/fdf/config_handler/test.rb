require './Fdf_config_handler.rb'

comclass = Comments_class.new()

puts "File before"
filename = "../fdf.rb"
filecontent = IO.read "../fdf.rb"
print filecontent
print "_________________________________"
print "_________________________________"
print "_________________________________"
print "_________________________________"
print "_________________________________"
print "_________________________________"

ext = File.extname filename
puts "File after"
print r = Regexp.new(comclass.comment_regex(ext))
print filecontent.gsub(r, '')

#file_access.dump_config()
