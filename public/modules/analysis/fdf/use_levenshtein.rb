# -*- coding: utf-8 -*-

class UseLevenshtein
  attr_reader :results

  # Initialize UseLevenshtein class
  #
  # @param [Array] Array of hash that contains files to send to the levenshtein
  def initialize(file_hash)
    @file_hash = file_hash
    @results = []
    @file_hash.each_value {|value| level(value)}
  end


  # Send files 2 by 2 at the levenshtein.
  # Fill fdupes_tab, Array that will contains files that will have matched
  # Fill lev_results, Array that will contains results of the levenshtein for each compared files
  # lev_results[0] = fdupes_tab[0] && fdupes_tab[1]
  # Each fill is sent to the levenshtein with all other files in the Array.
  #
  # @param [Array] File array that will be sent to the levenshtein.
  def send_levenshtein(file_to_send)
    size = file_to_send.size()
    (0..(size - 2)).each do |i|
      ((i + 1)..size - 1).each do |j|
        file1 = file_to_send[i].split('/')
        file2 = file_to_send[j].split('/')
        distance = Algorithms.levenshtein(file1.last(), file2.last())
        if distance <= 1
          @results << {
            files: [file_to_send[i], file_to_send[j]],
            distance: distance
          }
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
      send_levenshtein val
    end
  end
end
