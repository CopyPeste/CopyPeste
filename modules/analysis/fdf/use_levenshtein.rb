# -*- coding: utf-8 -*-

class UseLevenshtein
  attr_accessor :file_hash

  # Initialize UseLevenshtein class
  #
  # @param [Array] Array of hash that contains files to send to the levenshtein
  def initialize(file_hash)
    @file_hash = file_hash
    @fdupes_tab = []
    @lev_results = []
  end


  # Send files 2 by 2 at the levenshtein.
  # Fill fdupes_tab, Array that will contains files that will have matched
  # Fill lev_results, Array that will contains results of the levenshtein for each compared files
  # lev_results[0] = fdupes_tab[0] && fdupes_tab[1]
  # Each fill is sent to the levenshtein with all other files in the Array.
  #
  # @param [Array] File array that will be sent to the levenshtein.
  def send_levenshtein(file_to_send)
    i = 0
    index = 0
    size = file_to_send.size()
    (index..(size - 2)).each do |i|
      ((i+1)..size - 1).each do |j|
        file1 = file_to_send[i].split('/')
        file2 = file_to_send[j].split('/')
        if (result = Algorithms.levenshtein(file1.last(), file2.last())) <= 1
          @fdupes_tab << file_to_send[i]
          @fdupes_tab << file_to_send[j]
          @lev_results << result
        end
      end
      puts "#{i} / #{size-2}\n"
    end
  end


  # The level is use to get the files from a hash. The hash can have infinit level
  # What is call level is : hash[:c] => tab. There is one level of hash.
  #                         hash[:c] => hash[:size_file] => tab. There is two level of hash.
  #
  # @param [Hash] Hash that contains a tab of files that will be analysed
  def level(val)
    if val.instance_of? Hash
      val.each_value {|value| level(value)}
    else
      send_levenshtein(val)
    end
  end


  # start the process that will analyse files (first function to call)
  def start
    return nil if @file_hash.empty? == true
    @file_hash.each_value {|value| level(value)}
  end


  # Array[0] matched with Array[1]. Array[2] matched with Array[3] etc..
  # Usualy send to the Rsync to compare the content of those files
  #
  # @Return [Array] return the tab that contains multiple pair of files that have matched
  def get_file_matched
    @fdupes_tab
  end


  # This Array corresponds to the rsync_tab. lev_results[0] = leveshtein of rsync_tab[0] && rsync_tab[1]
  #
  # @Return [Array] return an Array of all results  matched from the levenshtein
  def get_levenshtein_result
    @lev_results
  end
end
