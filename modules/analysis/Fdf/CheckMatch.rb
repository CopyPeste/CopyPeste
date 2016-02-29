

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

# Send files to the fdup algorithms
def check_files_similarity(fdup_tab, lev_result)
  i = 0
  size = fdup_tab.size()
  puts fdup_tab
  #(i..size).each do |index|
  while i < size
    check_file_existe(fdup_tab, i)
    if File.size(fdup_tab[i]) == 0 || File.size(fdup_tab[i + 1]) == 0
      puts "Similaire"
    else
      puts IO.read(fdup_tab[i])
      puts IO.read(fdup_tab[i + 1])
    end
    #result_rsync = Algorithms.compare_files_match(fdup_tab[i], fdup_tab[i+1], 512) == 0
    #save_result_data(lev_result[index/2], result_rsync, fdup_tab[i], fdup_tab[i+1])
    i += 2
  end
end
