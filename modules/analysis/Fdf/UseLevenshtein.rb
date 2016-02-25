
class UseLevenshtein
  attr_accessor :file_hash

  def initialize(file_hash)
    @file_hash = file_hash
    @rsync_tab = []
  end


  # Send file 2 by 2 for analyse
  #
  # @param [Array] array of file who will be compare (each fill is compare with the other file in the Array)
  def send_levenshtein(file_to_send)
    tab = []
    i = 0
    j = 1
    while i != file_to_send.size() - 1
      while j != file_to_send.size()
        file1 = file_to_send[i].split('/')
        file2 = file_to_send[j].split('/')
        if (result = Algorithms.levenshtein(file1.last(), file2.last())) == 0
          @rsync_tab << file_to_send[i]
          @rsync_tab << file_to_send[j]
        end
        puts "#{file1.last} comparer avec  #{file2.last} pour le lev distance = #{result} \n"
        j += 1
      end
      i += 1
      j = i + 1
    end
    file_to_send.delete(file_to_send[0])
  end


  # The level is use to get the files from a hash. The hash can have infinit level
  # What is call level is : hash[:c] => tab. There is one level of hash.
  #                         hash[:c] => hash[:size_file] => tab. There is two level of hash.
  #
  # @param [Hash] who contain a tab of files witch will be analyse
  def level(val)
    if val.instance_of? Hash
      val.each_value {|value| level(value)}
    else
      send_levenshtein(val)
    end
  end
  

  # start the process for analyse (first function to call)
  def start
    if @file_hash.empty? == true
      return nil
    end
    @file_hash.each_value {|value| level(value)}
  end
  

  # Return the rsync_tab witch is the tab that contain multiple pair of files who matched
  # Usaly send to the Rsync to compare the content of those files
  def get_result
    return @rsync_tab
  end
end
