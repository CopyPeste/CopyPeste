
class UseRsync
  attr_accessor :rsync_tab, :lev_result

  # init UseRsync class
  #
  # @param [tab] tab of file wwitch will be compair.
  # be shure to have the good organisation : tab[0] compair with tab[1], tab[2] compair with tab[3]
  def initialize(rsync_tab, lev_result)
    @rsync_tab = rsync_tab
    @lev_result = lev_result
    @tab_send_to_mongo = []
  end


  def get_result_data
    @tab_send_to_mongo
  end

  def save_result_data(lev_result, rsync_result, file1, file2)
    tab = []
    tab << file1
    tab << file2
    result_data = {}
    result_data["levsht_dist"] = lev_result
    result_data["rsync_result"] = rsync_result
    result_data["files"] = tab
    @tab_send_to_mongo << result_data
  end


  # Send files to the Rsync algorithm
  def start
    i = 0
    j = 0
    while i != @rsync_tab.size()
      puts "#{@rsync_tab[i]} comparer avec  #{@rsync_tab[i+1]} pour le rsync\n"
      result_rsync = Algorithms.compare_files_match(@rsync_tab[i], @rsync_tab[i+1], 512) == 0
      save_result_data(@lev_result[j], result_rsync, @rsync_tab[i], @rsync_tab[i+1])
      i += 2
      j += 1
    end
  end
end
