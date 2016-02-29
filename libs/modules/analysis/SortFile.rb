# -*- coding: utf-8 -*-

# SortFile is use to sort any file by their extension and optionnal with their octe.
# It take a array of file to sort, and a array of octe or nil

class SortFile
  attr_accessor :octe


  # creat a instance of SortFile
  #
  # @param [Array] list of file to be sort
  # @param [Array] list of the size of each file witch will be use to sort the files,
  # can be nil if you do not want to sort by size (octe)
  def initialize()
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
  # @param [String] the extension of the files contain in file
  # @param [Integer] index use to increment the @octe list to sort by extension the différent file
  def sort_by_extension_and_size(file, extension, size)
    if @file_hash[:"#{extension}"] == nil
      new_hash = {}
      new_hash[:"#{size}"] = []
      new_hash[:"#{size}"] << file
      @file_hash[:"#{extension}"] = new_hash
    else
      my_hash = @file_hash[:"#{extension}"]
      if my_hash[:"#{size}"] == nil
        my_hash[:"#{size}"] = []
        my_hash[:"#{size}"] << file
      else
        my_hash[:"#{size}"] << file
      end
      @file_hash[:"#{extension}"] = my_hash
    end
  end

  
  # fill the hash who all file sort by extension
  #
  # @param [Array] array containing the file sort by extension, 
  # if the hash[extension] exsiste it will insert the last file of the tab
  # @parma [String] the extension of the files contain in file
  def sort_by_extension(file, extension)
    if @file_hash[:"#{extension}"] == nil
      @file_hash[:"#{extension}"] = []
      @file_hash[:"#{extension}"] << file
    else
      @file_hash[:"#{extension}"] << file
    end
  end



  def sort_by_size(file, size)
    if @file_hash[:"#{size}"] == nil
      @file_hash[:"#{size}"] = []
      @file_hash[:"#{size}"] << file
    else
      @file_hash[:"#{size}"] << file
    end    
  end


  def sort_no_rulls(file)
    if @file_hash[:files] == nil
      @file_hash[:files] = []
      @file_hash[:files] << file
    else
      @file_hash[:files] << file
    end
  end


  # return the hash containing all the file sort
  def get_hash
    
    return @file_hash
  end
end
