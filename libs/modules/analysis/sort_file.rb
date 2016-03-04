# -*- coding: utf-8 -*-

class SortFile
  attr_accessor :octe


  # creat a instance of SortFile
  def initialize()
    @file_hash = {}
  end


  # return the extension of a file
  #
  # @param [String] the complete path of a file
  # @Return [String] return the extension of a file
  def get_extension(fileName)
    file_extension = File.extname(fileName)
    file_extension = file_extension.split('.')
    file_extension.last
  end


  # Fill the hash. Files are sorted by extension and size
  #
  # @param [String] Complete path of the file
  # @param [String] Extension of the files
  # @param [Integer] size of the file
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


  # Fill the hash. Files are sorted by extension
  #
  # @param [String] Complete path of the file
  # @param [String] Extension of the files
  def sort_by_extension(file, extension)
    if @file_hash[:"#{extension}"] == nil
      @file_hash[:"#{extension}"] = []
      @file_hash[:"#{extension}"] << file
    else
      @file_hash[:"#{extension}"] << file
    end
  end


  # Fill the hash. Files are sorted by size
  #
  # @param [String] Complete path of the file
  # @param [Integer] size of the file
  def sort_by_size(file, size)
    if @file_hash[:"#{size}"] == nil
      @file_hash[:"#{size}"] = []
      @file_hash[:"#{size}"] << file
    else
      @file_hash[:"#{size}"] << file
    end    
  end


  # Fill the hash. Files are not sort
  #
  # @param [String] Complete path of the file
  def sort_no_rulls(file)
    if @file_hash[:files] == nil
      @file_hash[:files] = []
      @file_hash[:files] << file
    else
      @file_hash[:files] << file
    end
  end


  # @Return [Hash] return the hash containing all the files sorted
  def get_hash    
    return @file_hash
  end
end
