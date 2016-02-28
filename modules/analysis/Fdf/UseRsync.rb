
class UseRsync
  attr_accessor :rsync_tab, :lev_result

  # Initialize UseRsync class
  #
  # @param [Array] Array of file witch will be compaired.
  # Be shure to have the good organisation : Array[0] compair with Array[1], Array[2] compair with Array[3]
  # @param [Array] Array that contain results og the levenshtein. This array is link at the rsync_tab.
  # lev_result[0] = result of levenshtein(rsync_tab[0], rsync_tab[1])
  def initialize(rsync_tab, lev_result)
    @rsync_tab = rsync_tab
    @lev_result = lev_result
    @tab_send_to_mongo = []
  end


  # Return a tab of hash that contain all the result 
  # Array[0] => {"levsht_dist"=>0, "rsync_result"=>true, "files"=>["/path/file", "/path/file"], "_id"=>BSON::ObjectId('864sc4648')}
  def get_result_data
    @tab_send_to_mongo
  end


  # Save pair of file compared by Rsync/levenshtein, and the result of the Rsync and levenshtein in a Hash.
  # This Hash is saved in an Array
  #
  # @param [Integer] result of leveshtein for the two files send to the Rsync
  # @param [Bool] value of the two files compared by Rsync
  # @param [String] File 1 who was compared with File 2
  # @param [String] File 2 who was compared with File 1
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
