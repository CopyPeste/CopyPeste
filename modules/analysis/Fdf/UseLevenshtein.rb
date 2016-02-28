# -*- coding: utf-8 -*-

class UseLevenshtein
  attr_accessor :file_hash

  # Initialize UseLevenshtein class
  #
  # @param [Array] Array of hash that contain files to send to the levenshtein
  def initialize(file_hash)
    @file_hash = file_hash
    @rsync_tab = []
    @lev_results = []
  end

  

  # The threads of send_levenshtein
  def loop_and_send(i, j, file_to_send, rsync_tab, result_lev, size, range)
    while i <  size - 1
      j = i + 1
      while j < size
        file1 = file_to_send[i].split('/')
        file2 = file_to_send[j].split('/')
        if (result = Algorithms.levenshtein(file1.last(), file2.last())) == 0
          rsync_tab << file_to_send[i]
          rsync_tab << file_to_send[j]
          result_lev << result
        end
        j += 1
      end
      i += range
    end
  end
  
  # Send file 2 by 2 at the levenshtein.
  # Fill rsync_tab, Array that will contain files that will matched
  # Fill lev_results, Array that will cnotain lev_results og the levenshtein for each compared files
  # lev_results[0] = rsync_tab[0] && rsync_tab[1]
  #
  # @param [Array] Array of file that will be send to the levenshtein. 
  # Each fill is send to the levenshtein with all files in the Array.
  def send_levenshtein(file_to_send)
    index = 0
    nb_thread = 1
    threads = []
    size = file_to_send.size()

    #debut du thread
    while index < nb_thread
      threads << Thread.new(index, nb_thread) do |i, range|
        rsync_tab = []
        result_lev = []
        loop_and_send(i, 0, file_to_send, rsync_tab, result_lev, size, range)
        thread = Thread.current
        thread[:rsync] = rsync_tab
        thread[:result] = result_lev
      end
      index += 1
    end
    threads.each { |t| t.join }
    #fin du thread

    threads.each do |thread|
      thread[:rsync].each { |data| @rsync_tab << data }
      thread[:result].each { |data| @lev_results << data }
      thread.kill
    end
    puts "End of first ext"
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
  

  # start the process that will analyses files (first function to call)
  def start
    if @file_hash.empty? == true
      return nil
    end
    @file_hash.each_value {|value| level(value)}
  end

  # Return the rsync_tab witch is the tab that contain multiple pair of files who matched
  # Array[0] matched with Array[1]. Array[2] matched with Array[3] etc..
  # Usaly send to the Rsync to compare the content of those files
  def get_result_matched
    @rsync_tab
  end


  # Return an Array of all the result who matched from the levenshtein
  # This Array "correspond" at the rsync_tab. lev_results[0] = leveshtein of rsync_tab[0] && rsync_tab[1]
  def get_levenshtein_result
    @lev_results
  end
end
