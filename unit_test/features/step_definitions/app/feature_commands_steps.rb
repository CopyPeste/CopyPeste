# App Commands

Given /^step app commands loading$/ do

  Dir["./pathTests/app/commands/*.rb"].each do | file |
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
