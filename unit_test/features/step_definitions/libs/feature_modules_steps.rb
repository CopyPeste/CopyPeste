# Libs Modules
Given /^step libs modules loading$/ do

  Dir["./pathTests/libs/modules/*.rb"].each do | file |
    puts "Steps file: " + File.basename(file)

    nameFile = File.basename(file,File.extname(file))
    steps %{
        Given step #{nameFile} loading
        When step #{nameFile} checking
        Then step #{nameFile} resulting
    }
    puts "--------"
  end
end
