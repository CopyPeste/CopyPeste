
# This Object is use to send all the file who needs to be compare
# It take a simple array with the path of the files
# nothing is return for the moments 

class UseRsync
  attr_accessor :rsynctab

  def initialize(rsynctab)
    @rsynctab = rsynctab
  end

  def start
    i = 0
    puts "\n"
    while i != @rsynctab.size()
      puts "#{@rsynctab[i]} comparer avec  #{@rsynctab[i+1]} pour le rsync\n"
      if (Algorithms.compare_files_match(@rsynctab[i], @rsynctab[i+1], 512) == 0) then
        puts "SIMILARE"
      else
        puts "DIFFERENT"
      end
      i += 2
    end
    puts "\n"
  end
end
