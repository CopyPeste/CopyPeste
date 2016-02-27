# class use to scan all the file containe in a directory

require 'digest/md5'

class ScanSystem
  attr_accessor :start_point


  # Creat a ScanSystem instance
  #
  # @param [String] path of the start point to scan
  def initialize(start_point)
    @start_point = start_point
    @dir = Dir.new(@start_point)
    @file_hash = {}
    @tab_file = []
    @index = 0
  end
  

  # Start the scan of the system
  #
  # @parma [String] th path where you start ths scan
  def start(path)
    Dir.foreach(path) do |file|
      if file != "." && file != ".."
        tmp = path + "/" + file
        File.directory?(tmp) ? start(tmp) : put_in_list(tmp)
      end
    end
  end
  

  # put files scaned in the list to be sort later
  #
  # @parma [String] the file complet path (/home/test/toto.c)
  def put_in_list(file)
    @tab_file[@index] = file
    @index += 1
  end
  
  
  # return tab_file
  def get_tab_file
    @tab_file
  end
  
  
  # Send the file to SortFile object to be sort by there extension
  #
  # @parma [Array] array of the file scaned
  # @param [nil]/[Integer] here nil. 
  # Integer is use if you want to sort file by there extension et size in octe 
  def send_to_sort
    sort = SortFile.new(@tab_file, nil)
    sort.start
    @file_hash = sort.get_hash
  end


  # init the start point for the scan
  def init
    path = @start_point
    start(path)
  end


  # Return an hash of all the file sort by extension. and optionnaly extension plus size
  def get_sort_file
    @file_hash
  end
  
  
  # Take of the name file of the path (/home/test/toto.c => /home/test)
  #
  # @param [String] the all file path 
  def set_path(file)
    tab = file.split('/')
    tab.delete(tab.last)
    path = ""
    tab.each do |part_path|
      if part_path != ""
        path = path + "/" + part_path 
      end
    end
    path
  end
  

  # Creat an hash that will contain information of one file
  #
  # @param [ObjectId] the ObjectId of the extension (same ObjectId for all same extension)
  # @param [String] the complete path of the file
  def set_info_file(ext_id, files)
    if File.readable?(files) 
      hash_info = {}  # && File.stat(files).readable_real?
      name = File.split(files)
      name = name.last
      hash_info["name"] = name
      hash_info["path"] = set_path(files)
      hash_info["size"] = File.size(files)
      hash_info["ext"] = ext_id
      #hash_info["Sum"] = Digest::MD5.file(files)
      hash_info.to_json
    end
  end  
end
