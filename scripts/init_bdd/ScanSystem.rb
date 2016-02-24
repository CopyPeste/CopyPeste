#class use to scan all the file containe in a directory

require 'digest/md5'

class ScanSystem
  attr_accessor :start_point
  
  def initialize(start_point)
    @start_point = start_point
    @dir = Dir.new(@start_point)
    @file_hash = Hash.new
    @tab_file = Array.new
    @index = 0
  end
  

  def start(path)
    Dir.foreach(path) do |file|
      if file != "." && file != ".."
        tmp = path + "/" + file
        File.directory?(tmp) ? start(tmp) : put_in_list(tmp)
      end
    end
  end
  

  def put_in_list(file)
    @tab_file[@index] = file
    @index += 1
  end
  

  def send_to_sort
    sort = SortFile.new(@tab_file, nil)
    sort.start
    @file_hash = sort.get_hash
  end

  
  def init
    path = @start_point
    start(path)
  end
  

  def set_path(file)
    tab = file.split('/')
    tab.delete(tab.last)
    path = ""
    tab.each do |part_path|
      if part_path != ""
        path = path + "/" + part_path 
      end
    end
    return path
  end
  

  def set_info_file(ext_id, files)
    hash_info = Hash.new
    if File.readable?(files)
      name = File.split(files)
      name = name.last
      hash_info["name"] = name
      hash_info["path"] = set_path(files)
      hash_info["size"] = File.size(files)
      hash_info["ext"] = ext_id
      hash_info["Sum"] = Digest::MD5.file(files)
    end
    hash_info.to_json
  end
  

  def get_sort_file
    return @file_hash
  end
  
end
