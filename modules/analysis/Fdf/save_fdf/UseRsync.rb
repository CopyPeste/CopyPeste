
# This Object is use to send all the file who needs to be compare
# It take a simple array with the path of the files
# nothing is return for the moments 

class UseRsync
  attr_accessor :rsync_tab

  def initialize(rsync_tab)
    @rsync_tab = rsync_tab
  end

  def start
    i = 0
    puts "\n"
    while i != @rsync_tab.size()
      puts "#{@rsync_tab[i]} comparer avec  #{@rsync_tab[i+1]} pour le rsync\n"
      if (Algorithms.compare_files_match(@rsync_tab[i], @rsync_tab[i+1], 512) == 0) then
        puts "SIMILARE"
      else
        puts "DIFFERENT"
      end
      i += 2
    end
    puts "\n"
  end
end
