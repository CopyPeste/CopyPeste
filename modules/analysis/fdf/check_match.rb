# Save pair of file compared by fdupes/levenshtein, and there result
# This Hash is saved in an Array
#
# @param [Array] Array where will stock all the result of the analyses
# @param [Array] result of leveshtein
# @param [Array] result of fdupes
# @param [String] File 1 that was compared with File 2
# @param [String] File 2 that was compared with File 1
# @Return [Array] Return an Array that contain all results of analyses
def save_result_data(tab_send_to_mongo, lev_result, result_fdupes, file1, file2)
  tab = [file1, file2]
  result_data = {}
  result_data["levsht_dist"] = lev_result
  result_data["result_fdupes"] = result_fdupes
  result_data["files"] = tab
  tab_send_to_mongo << result_data
end


# Open the two files and send there containt to fdupes algorithm
#
# @param [Array] File Array
# @param [Integer] Loop position
# @return [Bool] Return whether the file don't match.
def open_and_send(fdup_tab, index)
  file1 = IO.read(fdup_tab[index])
  file2 = IO.read(fdup_tab[index + 1])
  #  if options == fdupes
  Algorithms.fdupes_match(file1, file1.length, file2, file2.length) == 0 ? false : true
  #  elsif options == diff
  #    Algorithms.diff(file1, file2)
  #  end
end


# Send files to the fdupes algorithms
#
# @param [Array] File Array to analyse
# @param [Array] Array of results of the levenshtein : lev_result[0] = levenshtein(fdup_tab[0], fdup_tab[1])
# @Return [Array] return an Array of hash that contain the result of the FDF modules
def check_files_similarity(fdup_tab, lev_result)
  i = 0
  tab_send_to_mongo = []
  size = fdup_tab.size()
  puts"\nSize : #{size} => #{fdup_tab}"
  ((i)..size - 1).each do |index|
    if index % 2 == 0
      if File.size(fdup_tab[index]) == File.size(fdup_tab[index + 1])
        condition = (File.size(fdup_tab[index]) > 0 && File.size(fdup_tab[index + 1]) > 0)
        result_fdupes = condition ? open_and_send(fdup_tab, index) : true
      else
        result_fdupes = true
      end
      tab_send_to_mongo = save_result_data(tab_send_to_mongo, lev_result[index/2],
                                           result_fdupes, fdup_tab[index], fdup_tab[index + 1])
    end
  end
  tab_send_to_mongo
end
