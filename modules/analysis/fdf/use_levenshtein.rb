# -*- coding: utf-8 -*-

class UseLevenshtein
  attr_accessor :file_hash

  # Initialize UseLevenshtein class
  #
  # @param [Array] Array of hash that contain files to send to the levenshtein
  def initialize(file_hash)
    @file_hash = file_hash
    @fdupes_tab = []
    @lev_results = []
  end

  
  # Send file 2 by 2 at the levenshtein.
  # Fill fdupes_tab, Array that will contain files that will matched
  # Fill lev_results, Array that will contain results of the levenshtein for each compared files
  # lev_results[0] = fdupes_tab[0] && fdupes_tab[1]
  # Each fill is send to the levenshtein with all the other files in the Array.
  #
  # @param [Array] Array of file that will be send to the levenshtein. 
  def send_levenshtein(file_to_send)
    tmp = 0
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
        puts "#{i} / #{size-2}  : Fichier => #{file1.last()} avec : #{file2.last()}\n"
      end
      tmp += 1
    end
  end


  # The level is use to get the files from a hash. The hash can have infinit level
  # What is call level is : hash[:c] => tab. There is one level of hash.
  #                         hash[:c] => hash[:size_file] => tab. There is two level of hash.
  #
  # @param [Hash] Hash that contain a tab of files witch will be analyse
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


  # Array[0] matched with Array[1]. Array[2] matched with Array[3] etc..
  # Usaly send to the Rsync to compare the content of those files
  #
  # @Return [Array] return the fdupes_tab witch is the tab that contain multiple pair of files who matched
  def get_file_matched
    @fdupes_tab
  end


  # This Array "correspond" at the rsync_tab. lev_results[0] = leveshtein of rsync_tab[0] && rsync_tab[1]
  #
  # @Return [Array] return an Array of all the result who matched from the levenshtein
  def get_levenshtein_result
    @lev_results
  end
end
