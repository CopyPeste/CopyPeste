# Modules Graphics
Given /^step modules graphics loading$/ do

  Dir["./pathTests/modules/graphics/*.rb"].each do | files |
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
