#class use to scan all the file containe in a directory

require 'digest/md5'

class ScanSystem
  attr_accessor :startPoint

def initialize(startPoint)
  @startPoint = startPoint
  @dir = Dir.new(@startPoint)
  @fileHash = Hash.new
  @tabFile = Array.new
  @index = 0
end

def start(path)
  Dir.foreach(path) do |file|
    if file != "." && file != ".."
      tmp = path+"/"+file
      if File.directory?(tmp)
        start(tmp)
      else
        putInList(tmp)
      end
    end
  end
end

def putInList(file)
  @tabFile[@index] = file
  @index += 1
end

def sendToSort
  sort = SortFile.new(@tabFile, nil)
  sort.start
  @fileHash = sort.getHash
end

def init
  path = @startPoint
  start(path)
end

def set_info_file(ext_id, files)
  hash_info = Hash.new
  if File.readable?(files)
    name = File.split(files)
    name = name.last
    hash_info["name"] = name
    hash_info["path"] = files
    hash_info["size"] = File.size(files)
    hash_info["ext"] = ext_id
    hash_info["Sum"] = Digest::MD5.file(files)
  end
  return hash_info.to_json
end

def getSortFile
  return @fileHash
end

end
