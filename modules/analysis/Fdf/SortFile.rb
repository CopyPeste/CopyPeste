# -*- coding: utf-8 -*-

# SortFile is use to sort any file by their extension and optionnal with their octe.
# It take a array of file to sort, and a array of octe or nil

class SortFile
  attr_accessor :list, :octe, :fileHash, :rsynctab


  # creat a instance of SortFile
  #
  # @param [Array] list of file to be sort
  # @param [Array] list of the size of each file witch will be use to sort the files,
  # can be nil if you do not want to sort by size (octe)
  def initialize(list, octe)
    @list = list
    @octe = octe
    @file_hash = {}
  end


  # return the extension of a file
  #
  # @param [String] th complete path of th file
  def get_extension(fileName)
    file_extension = File.extname(fileName)
    file_extension = file_extension.split('.')
    file_extension.last
  end


  # fill the hash who contain all file sort by extension and size (octe)
  #
  # @param [Array] array containing the file sort by extension and size, if the hash[extension] and
  # hash[octe] exsit it will take only the last file insert into the tab
  # @param [String] the extension of the files contain in tab_file
  # @param [Integer] index use to increment the @octe list to sort by extension the différent file
  def fill_hash_with_octe(tab_file, extension, i)
    if @file_hash[:"#{extension}"] == nil
      new_hash = {}
      new_hash[:"#{@octe[i]}"] = tab_file
      @file_hash[:"#{extension}"] = new_hash
    else
      my_hash = @file_hash[:"#{extension}"]
      if my_hash[:"#{@octe[i]}"] == nil
        my_hash[:"#{@octe[i]}"] = tab_file
      else
        my_hash[:"#{@octe[i]}"] << tab_file[0]
      end
      @file_hash[:"#{extension}"] = my_hash
    end
  end

  
  # fill th hash who all file sort by extension
  #
  # @param [Array] array containing the file sort by extension, 
  # if the hash[extension] exsiste it will insert the last file of the tab
  # @parma [String] the extension of the files contain in tab_file
  def fill_hash(tab_file, extension)
    if @file_hash[:"#{extension}"] == nil
      @file_hash[:"#{extension}"] = tab_file
    else
      my_hash = @file_hash[:"#{extension}"]
      @file_hash[:"#{extension}"] << tab_file[0]
    end
  end


  # start to sort file from the array list who contain the list of files to sort,
  # call fill_hash in each loop and add file one by one in tab_file
  def start
    i = 0
    list.each do |file_name|
      if (extension = get_extension(file_name)) == ""
        extension = "Other"
      end
      tab_file = []
      tab_file << file_name
      if @octe == nil || @octe.empty? == true
        fill_hash(tab_file, extension)
      else
        fill_hash_with_octe(tab_file, extension, i)
      end
      i += 1
    end
  end


  # return the hash containing all the file sort
  def get_hash
    return @file_hash
  end
end
