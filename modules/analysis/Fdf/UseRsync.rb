
class UseRsync
  attr_accessor :rsync_tab

  # init UseRsync class
  #
  # @param [tab] tab of file wwitch will be compair.
  # be shure to have the good organisation : tab[0] compair with tab[1], tab[2] compair with tab[3]
  def initialize(rsync_tab)
    @rsync_tab = rsync_tab
  end


  # Send files to the Rsync algorithm
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
