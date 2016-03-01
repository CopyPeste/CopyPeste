
# Save pair of file compared by Rsync/levenshtein, and the result of the Rsync and levenshtein in a Hash.
# This Hash is saved in an Array
#
# @param [Integer] result of leveshtein for the two files send to the Rsync
# @param [Bool] value of the two files compared by Rsync
# @param [String] File 1 who was compared with File 2
# @param [String] File 2 who was compared with File 1
def save_result_data(tab_send_to_mongo, lev_result, result_fdupes, file1, file2)
  tab = []
  tab << file1 << file2
  result_data = {}
  result_data["levsht_dist"] = lev_result
  result_data["result_fdupes"] = result_fdupes
  result_data["files"] = tab
  tab_send_to_mongo << result_data
end

# Send files to the fdup algorithms
def check_files_similarity(fdup_tab, lev_result)
  i = 0
  tab_send_to_mongo = []
  size = fdup_tab.size()
  puts"\nSize : #{size} => #{fdup_tab}"
  ((i)..size - 1).each do |index|
    if index % 2 == 0
      puts "file at index #{index} compare with index #{index + 1} with lev index #{index/2}"
      if File.size(fdup_tab[index]) != File.size(fdup_tab[index + 1])
        #puts IO.read(fdup_tab[i])
        #puts IO.read(fdup_tab[i + 1])
        #result_fdupes = Algorithms.compare_files_match(fdup_tab[i], fdup_tab[i+1], 512) == 0
      else
        result_fdupes = true
      end
      tab_send_to_mongo = save_result_data(tab_send_to_mongo, lev_result[index/2], result_fdupes, fdup_tab[index], fdup_tab[index + 1])
    end
  end
  puts "end"
  puts tab_send_to_mongo
end
